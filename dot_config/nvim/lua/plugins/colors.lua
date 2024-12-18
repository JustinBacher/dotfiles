return {
	-- Themes
	-- TODO: Figure out if I can turn lazy to true for all but current theme
	{
		"eldritch-theme/eldritch.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			styles = {
				properties = { "italic" },
				property = { "italic" },
				conditionals = { "italic" },
				types = { "bold" },
				parameter = { "italic" },
				variable = { "italic" },
			},
		},
	},
	{
		"Mofiqul/dracula.nvim",
		name = "dracula",
		priority = 1000,
		opts = { transparent_bg = true, italic_comment = true },
	},
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		priority = 1000,
		opts = {
			transparent = true,
			styles = { sidebars = "transparent", floats = "transparent" },
			on_highlights = function(hl, c) --- @diagnostic disable-line: unused-local
				hl.MiniCursorword = { underline = true }
				hl.MiniCursorwordCurrent = { underline = true }
				hl.DiagnosticVirtualTextError = { bg = "NONE", fg = "#db4b4b" }
				hl.DiagnosticVirtualTextWarn = { bg = "NONE", fg = "#e0af68" }
				hl.DiagnosticVirtualTextInfo = { bg = "NONE", fg = "#0db9d7" }
				hl.DiagnosticVirtualTextHint = { bg = "NONE", fg = "#1abc9c" }
			end,
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = { transparent_background = true },
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		opts = { extend_background_behind_borders = false, styles = { transparency = true } },
	},

	-- Themery - Theme Picker
	{
		"zaldih/themery.nvim",
		lazy = false,
		cmd = "Themery",
		config = function()
			local status_ok, themery = pcall(require, "themery")
			if not status_ok then return end
			themery.setup({
				themes = {
					{ name = "Dracula Dark", colorscheme = "dracula" },
					{ name = "Dracula Soft", colorscheme = "dracula-soft" },
					{ name = "Tokyonight Storm", colorscheme = "tokyonight-night" },
					{ name = "Tokyonight Night", colorscheme = "tokyonight-night" },
					{ name = "Tokyonight Moon", colorscheme = "tokyonight-moon" },
					{ name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
					{ name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
					{ name = "Rose Pine Moon", colorscheme = "rose-pine-moon" },
					{ name = "Eldritch", colorscheme = "eldritch" },
				},
				livePreview = true,
			})
		end,

		keys = {
			{ "<leader>tt", "<cmd>:Themery<cr>", desc = "Open Theme Picker" },
		},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		event = "LazyFile",
		opts = {
			render = "virtual",
			virtual_symbol = "",
			enable_tailwind = true,
		},
	},
}
