local opt = vim.opt
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.cursorline = false
opt.linebreak = false
opt.shiftwidth = 4
opt.tabstop = 4

opt.smoothscroll = false
