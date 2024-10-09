vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.cmd("au ColorScheme * hi Comment cterm=italic gui=italic") -- This fixed the italics not showing up for some reason
