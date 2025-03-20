return {
    "Wansmer/treesj",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
    keys = {
        {
            "<Leader>j",
            function()
                require("treesj").toggle()
            end,
            desc = "Toggle treesj",
        },
        {
            "<Leader>J",
            function()
                require("treesj").toggle({ split = { recursive = true } })
            end,
            desc = "Toggle treesj recursive",
        },
    },
    opts = {
        use_default_keymaps = false,
        max_join_length = 200,
    },
}
