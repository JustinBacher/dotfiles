local map = LazyVim.safe_keymap_set

-- Move Lines
map("n", "<c-a-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "move down" })
map("n", "<c-a-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "move up" })
map("i", "<c-a-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "move down" })
map("i", "<c-a-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "move up" })
map("v", "<c-a-j>", ":<c-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "move down" })
map("v", "<c-a-k>", ":<c-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "move up" })

-- Buffers
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "next buffer" })
map("n", "<s-tab>", "<cmd>bprevious<cr>", { desc = "prev buffer" })

-- Miscellaneous
map("n", "<esc>", "<cmd>noh<cr><esc>", {desc = "Escape and Clear hlsearch"})
map("n", "<CR>", "o<Esc>", {desc = "Add new line below"})
map("n", "?", ":%s/", {desc = "Search and replace"})
