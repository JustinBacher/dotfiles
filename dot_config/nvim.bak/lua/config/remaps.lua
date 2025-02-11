NOT_INSERT = { "n", "x", "v", "o" }

return {
	-- Global ease of use
	{ "<leader>qq", "<cmd>qa<cr>", desc = "Quit all buffers" },
	{ "<leader>qb", "<cmd>bd<cr>", desc = "Quit current buffer" },
	{ "<leader>bd", "<cmd>bd<cr>", desc = "Quit current buffer" },
	{ "<leader>qw", "<cmd>wq<cr>", desc = "Write current buffer and Quit" },
	{ "<leader>l", "<cmd>Lazy<cr>", desc = "Open Lazy" },
	{ "<leader>w", "<cmd>w<cr><esc>", desc = "Write file" },

	-- Movement
	{ "J", "<C-d>zz", mode = NOT_INSERT, desc = "Move up half page" },
	{ "K", "<C-u>zz", mode = NOT_INSERT, desc = "Move up half page" },
	{ "H", "^", mode = NOT_INSERT, desc = "Easier goto beginning of line" },
	{ "L", "$", mode = NOT_INSERT, desc = "Easier goto end of line" },

	-- Moving lines
	{ "<A-J>", "<cmd>m .+1<cr>==", desc = "Move Line Down" },
	{ "<A-K>", "<cmd>m .-2<cr>==", desc = "Move Line Up" },
	{ "<A-J>", "<cmd>m '>+1<CR>gv=gv", mode = "v", desc = "Move Line Down" },
	{ "<A-K>", "<cmd>m '<-2<CR>gv=gv", mode = "v", desc = "Move Line Up" },

	-- Tabs
	{ "<Tab>", "<cmd>bnext<cr>", mode = NOT_INSERT, desc = "Next Tab" },
	{ "<S-Tab>", "<cmd>bprevious<cr>", mode = NOT_INSERT, desc = "Previous Tab" },

	-- Windows
	{ "<leader>wd", "<C-w>c", mode = NOT_INSERT, desc = "Delete Window" },
	{ "<leader>wj", "<C-w>s", mode = NOT_INSERT, desc = "Split Window Below" },
	{ "<leader>wl", "<C-w>v", mode = NOT_INSERT, desc = "Split Window Right" },
	{ "<leader>wrh", "<Cmd>vertical resize -5", desc = "Resize Window Up" },
	{ "<leader>wrj", "<Cmd>resize +5", desc = "Resize Window Down" },

	-- Miscellaneous
	{ "<leader>ll", "<cmd>lopen<cr>", desc = "Location List" },
	{ "<leader>qf", "<cmd>copen<cr>", desc = "Quickfix List" },
	{ "U", "<C-r>", desc = "Redo" },
	{ "u", "~", mode = "v", desc = "Toggle case" },
	{ "<esc>", "<cmd>noh<cr><esc>", desc = "Escape and Clear hlsearch" },
	{ "gj", "J", mode = NOT_INSERT, desc = "Join line below. (remap of J)" },
	{ "<CR>", "o<Esc>", desc = "Add new line below" },
	{ "?", ":%s/", desc = "Search and replace" },
}
