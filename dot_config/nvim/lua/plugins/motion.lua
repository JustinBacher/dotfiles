local harpoon_keys = {}
for i = 1, 10 do
	table.insert(
		harpoon_keys,
		{ "<C-" .. i .. ">", function() require("harpoon"):list():select(i) end, desc = "Harpoon File " .. i }
	)
end

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
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = vim.tbl_extend("force", harpoon_keys, {
			{ "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon: Mark File" },
			{
				"<C-e>",
				function()
					local h = require("harpoon")
					h.ui:toggle_quick_menu(h:list())
				end,
				desc = "Toggle Harpoon Menu",
			},
		}),
	},
	{
		"letieu/harpoon-lualine",
		dependencies = { "ThePrimeagen/harpoon" },
	},
}
