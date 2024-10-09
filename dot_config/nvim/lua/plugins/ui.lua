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
	{ "stevearc/dressing.nvim",      event = "VeryLazy", config = true },
	{ "echasnovski/mini.cursorword", event = "LazyFile", config = true },
	{ "gen740/SmoothCursor.nvim",    event = "LazyFile", opts = { matrix = { enable = true } }, },
	{ "echasnovski/mini.animate",    event = "LazyFile", opts = { scroll = { enable = false }, resize = { enable = false } } },
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
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				for hl, color in pairs(opts) do
					vim.api.nvim_set_hl(0, hl, { fg = color })
				end
			end)
			vim.g.rainbow_delimiters = { highlight = opts }
			require("ibl").setup({ scope = { highlight = opts } })
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = { use_diagnostic_signs = true },
		-- stylua: ignore start
		keys = { -- LuaFormatter off
			{ "<leader>dx", "<Cmd>Trouble<CR>",                                       desc = "Toggle Trouble" },
			{ "<leader>dw", trouble("toggle", "workspace_diagnostics"),               desc = "Workspace Diagnostics" },
			{ "<leader>dd", trouble("toggle", "document_diagnostics"),                desc = "Document Diagnostics" },
			{ "<leader>dq", trouble("toggle", "quickfix"),                            desc = "Trouble Quickfix" },
			{ "<leader>dl", trouble("toggle", "loclist"),                             desc = "Trouble Location List" },
			{ "gR",         trouble("toggle", "lsp_references"),                      desc = "Trouble Lsp References" },
			{ "<leader>dn", trouble("next", { skip_groups = true, jump = true }),     desc = "Trouble Next Diagnostic" },
			{ "<leader>dp", trouble("previous", { skip_groups = true, jump = true }), desc = "Trouble Previous Diagnostic" },
		}, -- LuaFormatter on
		-- stylua: ignore stop
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "LazyFile",
		dependencies = { "nvim-tree/nvim-web-devicons", "letieu/harpoon-lualine", "folke/noice.nvim" },
		opts = {
			options = {
				theme = "tokyonight",
				component_separators = { left = "▒", right = "▒" },
				section_separators = {},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "diff", "diagnostics" },
				lualine_c = { "harpoon2" },
				lualine_x = {
					function()
						local n = require("noice")
						return {
							---@diagnostic disable: undefined-field
							{ n.api.status.message.get_hl, cond = n.api.status.message.has },
							{ n.api.status.command.get,    cond = n.api.status.command.has, color = { fg = "#ff9e64" } },
							{ n.api.status.mode.get,       cond = n.api.status.mode.has,    color = { fg = "#ff9e64" } },
							{ n.api.status.search.get,     cond = n.api.status.search.has,  color = { fg = "#ff9e64" } },
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
				dashboard.button("p", "󱌢  --> Find file (Projects)",
					":cd $HOME/projects<CR><Cmd>Telescope find_files<CR>"),
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
		keys = {
			{ "<leader>nd", dismiss_all_notifications,   desc = "Dismiss All Notifications" },
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
					["cmp.entry.get_documentation"] = true,
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
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				--- @diagnostic disable-next-line: unused-local
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					return " " .. level:match("error") and " " or " " .. count
				end,
			},
		},
	},
}
