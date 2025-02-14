local map = LazyVim.safe_keymap_set

-- Movement
map({ "n", "x", "v", "o" }, "<C-u>", "<C-d>zz", { desc = "Move down half page", noremap = true })
map({ "n", "x", "v", "o" }, "<C-u>", "<C-u>zz", { desc = "Move up half page", noremap = true })

-- Buffers
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "next buffer" })
map("n", "<s-tab>", "<cmd>bprevious<cr>", { desc = "prev buffer" })

-- Miscellaneous
map("n", "<esc>", "<cmd>noh<cr><esc>", {desc = "Escape and Clear hlsearch"})
map("n", "<CR>", "o<Esc>", {desc = "Add new line below"})
map("n", "?", ":%s/", {desc = "Search and replace"})
