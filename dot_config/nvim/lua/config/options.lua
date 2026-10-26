local opt = vim.opt
local g = vim.g
local api = vim.api

opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.cursorline = false
opt.linebreak = false
opt.shiftwidth = 4
opt.tabstop = 4
opt.smoothscroll = false

api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
    end,
})

api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.json",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

g.snacks_animate = false

vim.g.lazyvim_python_ruff = "ruff"
