local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.cmd("au ColorScheme * hi Comment cterm=italic gui=italic") -- This fixed the italics not showing up for some reason

-- Indentation/formatting rules
opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = true
opt.expandtab = true
opt.smartindent = true

-- Undo file
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- UI
opt.termguicolors = true
opt.relativenumber = true
opt.updatetime = 50
vim.opt.colorcolumn = "80"
opt.signcolumn = "yes"
opt.cursorline = true
vim.opt.scrolloff = 8
opt.wrap = false
opt.linebreak = true

-- Searching
opt.ignorecase = true
opt.smartcase = true
vim.opt.incsearch = true
