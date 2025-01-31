return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- set this if you want to always pull the latest change
	opts = {
		provider = "ollama",
		claude = {
			endpoint = "https://api.anthropic.com",
			model = "claude-3-5-sonnet-20241022",
			temperature = 0,
			max_tokens = 4096,
		},
		vendors = {
			ollama = {
				api_key_name = "",
				ask = "",
				endpoint = "http://127.0.0.1:11434/api",
				model = "hf.co/Qwen/Qwen2.5-Coder-3B-Instruct-GGUF:Q6_K",
				parse_curl_args = function(opts, code_opts)
					return {
						url = opts.endpoint .. "/chat",
						headers = {
							["Accept"] = "application/json",
							["Content-Type"] = "application/json",
						},
						body = {
							model = opts.model,
							options = {
								num_ctx = 16384,
							},
							messages = require("avante.providers").copilot.parse_messages(code_opts), -- you can make your own message, but this is very advanced
							stream = true,
						},
					}
				end,
				parse_stream_data = function(data, handler_opts)
					-- Parse the JSON data
					local json_data = vim.fn.json_decode(data)
					-- Check if the response contains a message
					if json_data and json_data.message and json_data.message.content then
						-- Extract the content from the message
						local content = json_data.message.content
						-- Call the handler with the content
						handler_opts.on_chunk(content)
					end
				end,
			},
		},
		behaviour = {
			auto_suggestions = true, -- Experimental stage
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = false,
			minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
		},
		file_selector = { provider = "fzf", provider_opts = {} },
	},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"echasnovski/mini.pick",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
		"ibhagwan/fzf-lua",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua",
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	keys = {
		{
			"<leader>aa",
			function() require("avante.api").ask() end,
			desc = "avante: ask",
			mode = { "n", "v" },
		},
		{
			"<leader>ar",
			function() require("avante.api").refresh() end,
			desc = "avante: refresh",
		},
		{
			"<leader>ae",
			function() require("avante.api").edit() end,
			desc = "avante: edit",
			mode = "v",
		},
	},
}
