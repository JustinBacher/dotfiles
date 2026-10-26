-- Monitor geometry and application/workspace assignments.
local monitors = {
	primary = "DP-7",
	left = "HDMI-A-3",
	right = "DP-9",
}

hl.monitor({ output = monitors.left, mode = "1600x900@74.89", position = "0x0", scale = 1 })
hl.monitor({ output = monitors.primary, mode = "1920x1080@100", position = "700x900", scale = 1 })
hl.monitor({ output = monitors.right, mode = "1600x900@74.89", position = "1600x0", scale = 1 })
hl.monitor({ output = "Virtual-1", mode = "3024x1890@120", position = "auto", scale = 2 })

local placement_rules = {
	{ name = "placement-foot-workspace", match = { title = "foot" }, workspace = "1" },
	{ name = "placement-ghostty-workspace", match = { title = "ghostty" }, workspace = "1" },
	{ name = "placement-wezterm-workspace", match = { title = "wezterm" }, workspace = "1" },
	{ name = "placement-kitty-workspace", match = { title = "kitty" }, workspace = "1" },
	{ name = "placement-zen-workspace", match = { title = "zen" }, workspace = "2" },
	{ name = "placement-firefox-workspace", match = { title = "firefox" }, workspace = "2" },
	{ name = "placement-chromium-workspace", match = { title = "chromium" }, workspace = "2" },
	{ name = "placement-google-chrome-workspace", match = { class = "google-chrome" }, workspace = "8" },
	{ name = "placement-gog-galaxy-workspace", match = { title = "gog galaxy" }, workspace = "3" },
	{ name = "placement-ubisoft-connect-workspace", match = { title = "ubisoft connect" }, workspace = "3" },
	{ name = "placement-origin-workspace", match = { title = "origin" }, workspace = "3" },
	{ name = "placement-epic-games-workspace", match = { title = "epic games" }, workspace = "3" },
	{ name = "placement-wine-workspace", match = { title = "wine" }, workspace = "3" },
	{ name = "placement-steam-workspace", match = { title = "steam" }, workspace = "3" },
	{ name = "placement-overwatch-workspace", match = { title = "overwatch" }, workspace = "3" },
	{ name = "placement-wine-system-tray-workspace", match = { title = "wine system tray" }, workspace = "3" },
	{ name = "placement-battle-net-workspace", match = { title = "battle.net" }, workspace = "3" },
	{ name = "placement-blizzard-workspace", match = { title = "blizzard" }, workspace = "3" },
	{ name = "placement-lutris-workspace", match = { title = "lutris" }, workspace = "3" },
	{ name = "placement-discord-workspace", match = { title = "discord" }, workspace = "4" },
	{ name = "placement-vesktop-workspace", match = { title = "vesktop" }, workspace = "4" },
	{ name = "placement-spotify-workspace", match = { title = "spotify" }, workspace = "5" },
}

for _, rule in ipairs(placement_rules) do
	hl.window_rule(rule)
end

local workspace_monitors = {
	monitors.primary,
	monitors.left,
	monitors.primary,
	monitors.right,
	monitors.right,
	monitors.right,
	monitors.right,
	monitors.left,
	monitors.right,
	monitors.primary,
}
for workspace, output in ipairs(workspace_monitors) do
	hl.workspace_rule({ workspace = tostring(workspace), monitor = output })
end

hl.workspace_rule({ workspace = "1", layout = "scrolling", layout_opts = { direction = "right" } })

-- Avoid the Hyprland 0.56 scrolling-fullscreen pointer regression on the game workspace.
hl.workspace_rule({ workspace = "3", layout = "dwindle" })
