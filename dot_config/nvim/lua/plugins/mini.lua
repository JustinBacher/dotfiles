return {
    {
        "echasnovski/mini.animate",
        opts = {
            cursor = { enabled = false },
            scroll = { enabled = false },
        },
    },
    {
        "echasnovski/mini.files",
        lazy = false,
        opts = {
            windows = {
                preview = true,
                width_focus = 30,
                width_preview = 60,
            },
            options = {
                -- Whether to use for editing directories
                -- Disabled by default in LazyVim because neo-tree is used for that
                use_as_default_explorer = true,
            },
        },
        keys = {
            {
                "<leader>e",
                function()
                    require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
                end,
                desc = "Open mini.files (Directory of Current File)",
            },
            {
                "<leader>fm",
                function()
                    require("mini.files").open(vim.uv.cwd(), true)
                end,
                desc = "Open mini.files (cwd)",
            },
        },
    },
}
