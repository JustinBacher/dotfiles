const ENDPOINT = process.env.OMP_CUDA_TTS_URL ?? "http://127.0.0.1:8880/v1/audio/speech";
const VOICE = process.env.OMP_CUDA_TTS_VOICE ?? "am_onyx";
const SPEED = Number.parseFloat(process.env.OMP_CUDA_TTS_SPEED ?? "1");
const SAMPLE_RATE = 24_000;
const MAX_CHARS = 600;

type MessageContent = string | Array<{ type?: string; text?: string }>;

interface AgentMessage {
	role?: string;
	content?: MessageContent;
}

interface ExtensionContext {
	mode: "tui" | "rpc" | "json" | "print";
	agent: { kind: "main" | "sub" };
	ui: { notify(message: string, level?: "info" | "warning" | "error"): void };
}

interface ExtensionAPI {
	setLabel(label: string): void;
	on(event: "agent_start" | "agent_end" | "session_stop" | "session_shutdown", handler: (event: unknown, ctx: ExtensionContext) => unknown): void;
	on(event: "message_end", handler: (event: { message: AgentMessage }, ctx: ExtensionContext) => unknown): void;
}

interface PlaybackProcess {
	readonly stdin: {
		write(chunk: Uint8Array): number;
		flush(): number | Promise<number>;
		end(): void;
	};
	readonly exited: Promise<number>;
	kill(): void;
}

function messageText(message: AgentMessage): string {
	if (typeof message.content === "string") return message.content;
	if (!Array.isArray(message.content)) return "";
	return message.content
		.filter(block => block.type === "text" && typeof block.text === "string")
		.map(block => block.text ?? "")
		.join("\n");
}

function normalizeForSpeech(markdown: string): string {
	return markdown
		.replace(/```[\s\S]*?```/g, " ")
		.replace(/^\s*\|.*\|\s*$/gm, " ")
		.replace(/^\s*[-:| ]{3,}\s*$/gm, " ")
		.replace(/!\[([^\]]*)\]\([^)]*\)/g, "$1")
		.replace(/\[([^\]]+)\]\([^)]*\)/g, "$1")
		.replace(/https?:\/\/\S+/g, " ")
		.replace(/`([^`]+)`/g, "$1")
		.replace(/^\s{0,3}(?:#{1,6}|>|[-+*]|\d+[.)])\s+/gm, "")
		.replace(/[*_~]+/g, "")
		.replace(/<[^>]+>/g, " ")
		.replace(/\s+/g, " ")
		.trim();
}

function splitForSpeech(text: string): string[] {
	const chunks: string[] = [];
	let remaining = text;
	while (remaining.length > MAX_CHARS) {
		const window = remaining.slice(0, MAX_CHARS + 1);
		const sentenceMatches = [...window.matchAll(/[.!?](?=\s)/g)];
		const sentenceEnd = sentenceMatches.at(-1)?.index;
		const whitespace = window.lastIndexOf(" ");
		const cut = sentenceEnd !== undefined && sentenceEnd >= MAX_CHARS / 3 ? sentenceEnd + 1 : Math.max(1, whitespace);
		chunks.push(remaining.slice(0, cut).trim());
		remaining = remaining.slice(cut).trimStart();
	}
	if (remaining) chunks.push(remaining);
	return chunks.filter(Boolean);
}

export default function cudaKokoro(pi: ExtensionAPI): void {
	pi.setLabel("CUDA Kokoro");

	let active = false;
	let generation = 0;
	let queue = Promise.resolve();
	let request: AbortController | null = null;
	let playback: PlaybackProcess | null = null;
	let warned = false;

	const stop = (): void => {
		active = false;
		generation += 1;
		request?.abort();
		request = null;
		playback?.kill();
		playback = null;
		queue = Promise.resolve();
	};

	const reportFailure = (ctx: ExtensionContext, cause: unknown): void => {
		const message = cause instanceof Error ? cause.message : String(cause);
		console.error(`[cuda-kokoro] ${message}`);
		if (!warned) {
			warned = true;
			ctx.ui.notify(`CUDA Kokoro unavailable: ${message}`, "warning");
		}
	};

	const synthesize = async (text: string, owner: number, ctx: ExtensionContext): Promise<void> => {
		if (!active || owner !== generation || text.length === 0) return;

		const controller = new AbortController();
		request = controller;
		try {
			const response = await fetch(ENDPOINT, {
				method: "POST",
				headers: { "content-type": "application/json" },
				body: JSON.stringify({
					model: "kokoro",
					input: text,
					voice: VOICE,
					response_format: "pcm",
					speed: Number.isFinite(SPEED) && SPEED > 0 ? SPEED : 1,
					stream: true,
				}),
				signal: controller.signal,
			});
			if (!response.ok) throw new Error(`HTTP ${response.status}: ${(await response.text()).slice(0, 240)}`);
			if (!response.body) throw new Error("speech endpoint returned no audio stream");
			if (!active || owner !== generation) return;

			const process = Bun.spawn(
				[
					"/usr/bin/pw-play",
					"--raw",
					"--format=s16",
					`--rate=${SAMPLE_RATE}`,
					"--channels=1",
					"--media-role=Communication",
					"-",
				],
				{ stdin: "pipe", stdout: "ignore", stderr: "ignore" },
			) as unknown as PlaybackProcess;
			playback = process;

			const reader = response.body.getReader();
			while (active && owner === generation) {
				const chunk = await reader.read();
				if (chunk.done) break;
				if (chunk.value.length > 0) {
					process.stdin.write(chunk.value);
					await process.stdin.flush();
				}
			}
			process.stdin.end();
			const exitCode = await process.exited;
			if (active && owner === generation && exitCode !== 0) throw new Error(`pw-play exited with code ${exitCode}`);
			warned = false;
		} catch (cause) {
			if (!controller.signal.aborted && active && owner === generation) reportFailure(ctx, cause);
		} finally {
			if (request === controller) request = null;
			if (playback) playback = null;
		}
	};

	const enqueue = (chunks: readonly string[], ctx: ExtensionContext): void => {
		const owner = generation;
		for (const chunk of chunks) queue = queue.then(() => synthesize(chunk, owner, ctx));
	};

	pi.on("agent_start", (_event, ctx) => {
		if (ctx.agent.kind !== "main") return;
		stop();
		active = true;
	});

	pi.on("message_end", (event, ctx) => {
		if (!active || ctx.agent.kind !== "main" || event.message.role !== "assistant") return;
		const text = normalizeForSpeech(messageText(event.message));
		enqueue(splitForSpeech(text), ctx);
	});

	pi.on("agent_end", async (_event, ctx) => {
		if (ctx.agent.kind === "main" && ctx.mode === "print") await queue;
	});

	pi.on("session_stop", () => stop());
	pi.on("session_shutdown", () => stop());
}
