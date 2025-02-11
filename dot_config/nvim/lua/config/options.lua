local opt = vim.opt
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.cursorline = false
opt.linebreak = false
opt.shiftwidth = 4
opt.tabstop = 4

if vim.fn.has("nvim-0.10") == 1 then
    opt.smoothscroll = false
end
