return {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    specs = {
        -- disable mini.animate cursor
        {
            "echasnovski/mini.animate",
            opts = {
                cursor = { enable = false },
                scroll = { enable = false },
            },
        },
    },
}
