local map = LazyVim.safe_keymap_set

-- Movement
map({ "n", "x", "v", "o" }, "<C-u>", "<C-d>zz", { desc = "Move down half page", noremap = true })
map({ "n", "x", "v", "o" }, "<C-u>", "<C-u>zz", { desc = "Move up half page", noremap = true })

-- Buffers
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "next buffer" })
map("n", "<s-tab>", "<cmd>bprevious<cr>", { desc = "prev buffer" })

-- Miscellaneous
map("n", "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
map("n", "<CR>", "o<Esc>", { desc = "Add new line below" })
map("n", "?", ":%s/", { desc = "Search and replace" })

-- Move lines
map("n", "<C-A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<C-A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<C-A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<C-A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<C-A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<C-A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
