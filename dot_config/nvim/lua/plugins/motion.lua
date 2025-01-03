return {
	{
		"folke/flash.nvim",
		config = true,
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function() require("flash").jump({ search = { forward = true, wrap = true } }) end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function() require("flash").jump({ pattern = vim.fn.expand("<cword>") }) end,
				desc = "Search using word under cursor",
			},
			{
				"<leader>ft",
				mode = { "o", "x" },
				function() require("flash").treesitter_search() end,
				desc = "Treesitter Search",
			},
		},
	},
	{
		"christoomey/vim-tmux-navigator",
		-- Migrating to smart-splits.nvim for more multiplexer support
		enabled = false,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		"mrjones2014/smart-splits.nvim",
		opts = { ignored_filetypes = { "NvimTree" } },
		setup = function()
			local wezterm = require("wezterm")
			local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
			local config = wezterm.config_builder()
			-- you can put the rest of your Wezterm config here
			smart_splits.apply_to_config(config, {
				direction_keys = { "h", "j", "k", "l" },
				modifiers = {
					move = "CTRL",
					resize = "CTRL SHIFT",
				},
			})
		end,
	},
	{
		"letieu/harpoon-lualine",
		dependencies = {
			{
				"ThePrimeagen/harpoon",
				branch = "harpoon2",
				dependencies = { "nvim-lua/plenary.nvim" },
				keys = {
					{ "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon: Mark File" },
					{
						"<C-e>",
						function()
							local h = require("harpoon")
							h.ui:toggle_quick_menu(h:list())
						end,
						desc = "Toggle Harpoon Menu",
					},
					{ "<C-t>", function() require("harpoon"):list():select(1) end, desc = "Harpoon File 1" },
					{ "<C-s>", function() require("harpoon"):list():select(2) end, desc = "Harpoon File 2" },
					{ "<C-b>", function() require("harpoon"):list():select(3) end, desc = "Harpoon File 3" },
					{ "<C-g>", function() require("harpoon"):list():select(4) end, desc = "Harpoon File 4" },
				},
			},
		},
	},
}
