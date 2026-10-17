return {
    "xvzc/chezmoi.nvim",
    init = function()
        local source_dir = vim.env.HOME .. "/.local/share/chezmoi/"
        local group = vim.api.nvim_create_augroup("chezmoi_source_watch", { clear = true })

        local function watch(bufnr)
            -- Capture the opened buffer: the current buffer may change before this runs.
            vim.schedule(function()
                if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
                    return
                end
                local path = vim.api.nvim_buf_get_name(bufnr)
                if vim.bo[bufnr].buftype == "" and path:sub(1, #source_dir) == source_dir then
                    require("chezmoi.commands.__edit").watch(bufnr)
                end
            end)
        end

        vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
            group = group,
            pattern = source_dir .. "*",
            callback = function(event)
                watch(event.buf)
            end,
        })

        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(bufnr) then
                watch(bufnr)
            end
        end
    end,
}
