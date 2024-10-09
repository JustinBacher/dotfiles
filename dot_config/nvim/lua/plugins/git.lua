local function git_commit_current_buffer()
	vim.ui.input({ prompt = "Message" }, function(message)
		if message == "" then print("No commit performed") end
		-- local path = vim.split(vim.fn.expand('%'), "/")
		-- local filename = table.remove(path, #path)
		vim.cmd("Git add " .. vim.fn.expand("%:p"))
		vim.cmd("Git commit  --message=" .. '"' .. message .. '"')

		-- vim.cmd("Git commit " .. message)
	end)
end

return {
	{
		"tpope/vim-fugitive",
		cmd = "Git",
		keys = {
			{ "<leader>gc", git_commit_current_buffer, desc = "Git add current file" },
			{ "<leader>gs", "<Cmd>Git status<CR>", desc = "Git status"},
			-- { "<leader>gl", },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		cmd = "GitSigns",
		keys = {
			{ "<leader>gp", "<Cmd>Gitsigns preview_hunk_inline<CR>", desc = "Preview hunk" },
			{ "<leader>gb", "<Cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle line blame" },
		},
		config = function()
			local signs = require("gitsigns")
			signs.setup()
			signs.toggle_current_line_blame()
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = "nvim-lua/plenary.nvim",
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
}
