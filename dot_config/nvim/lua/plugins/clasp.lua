return {
    "xzbdmw/clasp.nvim",
    lazy = true,
    config = function()
        require("clasp").setup({
            pairs = { ["{"] = "}", ['"'] = '"', ["'"] = "'", ["("] = ")", ["["] = "]", ["<"] = ">" },
            keep_insert_mode = true,
            remove_pattern = nil,
        })
    end,
    keys = {
        {
            "<C-;>",
            function()
                require("clasp").wrap("next")
            end,
            desc = "Wrap next",
            mode = { "n", "i" },
        },
        {
            "<C-:>",
            function()
                require("clasp").wrap("prev")
            end,
            desc = "Wrap prev",
            mode = { "n", "i" },
        },
    },
}
