-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("FileType", {
    pattern = "nix",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
    end,
})

-- avante's ACP agents (claude-code, codex) write edits straight to disk, so open buffers never
-- reload on their own while focus stays in the sidebar. Watch each file buffer and reload it.
local watchers = {}

local function stop_watch(bufnr)
    local handle = watchers[bufnr]
    if handle then
        handle:stop()
        handle:close()
        watchers[bufnr] = nil
    end
end

local function watch(bufnr)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" or vim.bo[bufnr].buftype ~= "" then return end
    stop_watch(bufnr)
    local handle = vim.uv.new_fs_event()
    if not handle then return end
    watchers[bufnr] = handle
    handle:start(path, {}, vim.schedule_wrap(function(err)
        if err or not vim.api.nvim_buf_is_valid(bufnr) then return stop_watch(bufnr) end
        -- Re-arm on every event: a write that renames over the file leaves the old inode unwatched.
        watch(bufnr)
        -- checktime on a modified buffer prompts, so only reload clean buffers.
        if not vim.bo[bufnr].modified then vim.cmd("checktime " .. bufnr) end
    end))
end

for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then watch(bufnr) end
end
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    callback = function(args) watch(args.buf) end,
})
vim.api.nvim_create_autocmd("BufWipeout", {
    callback = function(args) stop_watch(args.buf) end,
})
