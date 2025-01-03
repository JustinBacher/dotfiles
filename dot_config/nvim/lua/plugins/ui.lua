local function dismiss_all_notifications() require("notify").dismiss({ silent = true, pending = true }) end

local function trouble(cmd, opts)
	return function()
		local t = require("trouble")
		if cmd ~= "toggle" and not t.is_open() then t.open("document_diagnostics") end
		if opts then
			t[cmd](opts)
		else
			t[cmd]()
		end
	end
end

return {
	{ "MunifTanjim/nui.nvim", version = "*" },
	{ "stevearc/dressing.nvim", event = "VeryLazy", config = true },
	{ "echasnovski/mini.cursorword", event = "LazyFile", config = true },
	{ "gen740/SmoothCursor.nvim", event = "LazyFile", opts = { matrix = { enable = true } } },
	{
		"lewis6991/satellite.nvim",
		event = "LazyFile",
		opts = {
			width = 3,
			handlers = {
				cursor = {
					enable = false,
					symbols = { "⎺", "⎻", "⎼", "⎽" },
				},
				search = { enable = true },
				diagnostic = {
					enable = true,
					signs = { "󰈜", "=", "≡" },
					min_severity = vim.diagnostic.severity.HINT,
					-- Highlights:
					-- - SatelliteDiagnosticError (default links to DiagnosticError)
					-- - SatelliteDiagnosticWarn (default links to DiagnosticWarn)
					-- - SatelliteDiagnosticInfo (default links to DiagnosticInfo)
					-- - SatelliteDiagnosticHint (default links to DiagnosticHint)
				},
				gitsigns = {
					enable = true,
					signs = {
						add = "",
						change = "󰏬",
						delete = "",
					},
				},
				marks = {
					enable = true,
					show_builtins = false, -- shows the builtin marks like [ ] < >
					key = "m",
					-- Highlights:
					-- SatelliteMark (default links to Normal)
				},
				quickfix = {
					signs = { "-", "=", "≡" },
					-- Highlights:
					-- SatelliteQuickfix (default links to WarningMsg)
				},
			},
		},
	},
	{
		"OXY2DEV/markview.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = "markdown",
	},
	{
		"sphamba/smear-cursor.nvim",
		enabled = true,
		event = "LazyFile",
		opts = {
			legacy_computing_symbols_support = true,
		},
	},
	{
		"echasnovski/mini.animate",
		enabled = false,
		event = "LazyFile",
		opts = {
			scroll = { enable = false },
			resize = { enable = false },
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			RainbowRed = "#E06C75",
			RainbowYellow = "#E5C07B",
			RainbowBlue = "#61AFEF",
			RainbowOrange = "#D19A66",
			RainbowGreen = "#98C379",
			RainbowViolet = "#C678DD",
			RainbowCyan = "#56B6C2",
		},
		config = function(_, opts)
			vim.g.rainbow_delimiters = { highlight = opts }
			require("ibl").setup({ scope = { highlight = opts } })

			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				for hl, color in pairs(opts) do
					vim.api.nvim_set_hl(0, hl, { fg = color })
				end
			end)
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = { use_diagnostic_signs = true },
		-- stylua: ignore start
		keys = { -- LuaFormatter off
			{ "<leader>tx", "<Cmd>Trouble<CR>",                                       desc = "Toggle Trouble" },
			{ "<leader>tw", trouble("toggle", "workspace_diagnostics"),               desc = "Workspace Diagnostics" },
			{ "<leader>td", trouble("toggle", "document_diagnostics"),                desc = "Document Diagnostics" },
			{ "<leader>tq", trouble("toggle", "quickfix"),                            desc = "Trouble Quickfix" },
			{ "<leader>tl", trouble("toggle", "loclist"),                             desc = "Trouble Location List" },
			{ "<leader>tn", trouble("next", { skip_groups = true, jump = true }),     desc = "Trouble Next Diagnostic" },
			{ "<leader>tp", trouble("previous", { skip_groups = true, jump = true }), desc = "Trouble Previous Diagnostic" },
		}, -- LuaFormatter on
		-- stylua: ignore stop
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "LazyFile",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"letieu/harpoon-lualine",
			"folke/noice.nvim",
			"roobert/action-hints.nvim",
		},
		opts = {
			options = {
				theme = "tokyonight",
				component_separators = { left = "▒", right = "▒" },
				section_separators = {},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "diff", "diagnostics", "harpoon2" },
				lualine_c = { function() return { require("action-hints").statusline } end },
				lualine_x = {
					function()
						local n = require("noice")
						return {
							---@diagnostic disable: undefined-field
							{ n.api.status.message.get_hl, cond = n.api.status.message.has },
							{
								n.api.status.command.get,
								cond = n.api.status.command.has,
								color = { fg = "#ff9e64" },
							},
							{
								n.api.status.mode.get,
								cond = n.api.status.mode.has,
								color = { fg = "#ff9e64" },
							},
							{
								n.api.status.search.get,
								cond = n.api.status.search.has,
								color = { fg = "#ff9e64" },
							},
							---@diagnostic enable: undefined-field
						}
					end,
				},
				lualine_y = { "filetype", "progress" },
				lualine_z = { { "location", left_padding = 2 } },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "location" },
			},
			tabline = {},
			extensions = {},
		},
	},
	{
		"echasnovski/mini.map",
		event = "LazyFile",
		cmd = "MiniMap",
		keys = {
			{ "<leader>mm", "<Cmd>MiniMap.toggle()<CR>", desc = "Toggle MiniMap" },
		},
		config = function()
			local map = require("mini.map")
			map.setup({
				integrations = {
					map.gen_integration.builtin_search(),
					map.gen_integration.gitsigns(),
					map.gen_integration.diagnostic(),
				},
				window = { winblend = 90 },
			})
		end,
	},
	{
		"goolord/alpha-nvim",
		lazy = vim.fn.argc() ~= 0,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.header.val = require("config.icons").welcome
			-- stylua: ignore start
			dashboard.section.buttons.val = { -- LuaFormatter off
				dashboard.button("e", "  --> File tree", "<leader>e<CR>"),
				dashboard.button("f", "  --> Find file (cwd)", "<Cmd>Telescope find_files<CR>"),
				dashboard.button("p", "󱌢  --> Find file (Projects)", ":cd $HOME/projects<CR><Cmd>Telescope find_files<CR>"),
				dashboard.button("r", "  --> Recent files", "<Cmd>Telescope oldfiles<CR>"),
				dashboard.button("l", "󱘖  --> Load last session", "<Cmd>SessionManager load_last_session<CR>"),
				dashboard.button("h", "󰛔  --> Load session", "<Cmd>SessionManager load_session<CR>"),
				dashboard.button("n", "󰨇  --> Nvim settings", "cd $HOME/dotfiles/.config/nvim<CR><Cmd>NvimTreeOpen<CR>"),
				dashboard.button("s", "  --> System settings", "cd $HOME/dotfiles/<CR><Cmd>NvimTreeOpen<CR>"),
			} -- LuaFormatter on
			-- stylua: ignore end
			dashboard.section.footer.val = "Code is like humor. When you have to explain it, it’s bad."
			require("alpha").setup(dashboard.opts)
			vim.cmd("autocmd FileType alpha setlocal nofoldenable")
		end,
	},
	{
		"rcarriga/nvim-notify",
		lazy = false,
		keys = {
			{ "<leader>nd", dismiss_all_notifications, desc = "Dismiss All Notifications" },
			{ "<leader>nh", "<cmd>Telescope notify<cr>", desc = "Notification History" },
		},
		opts = {
			stages = "slide",
			render = "compact",
			background_colour = "FloatShadow",
			top_down = false,
			timeout = 3000,
			max_height = function() return math.floor(vim.o.lines * 0.75) end,
			max_width = function() return math.floor(vim.o.columns * 0.75) end,
			on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		opts = {
			cmdline = {
				format = {
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					substitute = { kind = "search", pattern = "^:%%s/", icon = "󰛔", lang = "regex" },
				},
			},
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["config.lsp.signature.enabled"] = true,
				},
				signature = { enabled = false },
				hover = { enabled = true },
			},
			-- you can enable a preset for easier configuration
			presets = {
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = true, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
			views = {
				cmdline_popup = {
					position = { row = 5, col = "50%" },
					size = { width = 60, height = "auto" },
				},
				popupmenu = {
					relative = "editor",
					position = { row = 8, col = "50%" },
					size = { width = 60, height = 10 },
					border = { style = "rounded", padding = { 0, 1 } },
					win_options = { winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" } },
				},
			},
			routes = { { view = "notify", filter = { event = "msg_showmode" } } },
		},
	},
	{
		"akinsho/bufferline.nvim",
		event = "LazyFile",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				--- @diagnostic disable-next-line: unused-local
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local s = " "
					for e, n in pairs(diagnostics_dict) do
						s = s .. n .. e == "error" and " " or (e == "warning" and " " or " ")
					end
					return s
				end,
			},
		},
	},
}
