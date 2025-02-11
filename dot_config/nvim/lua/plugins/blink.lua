return {
    "saghen/blink.cmp",
    opts_extend = {
        "sources.completion.enabled_providers",
        "sources.compat",
        "sources.default",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        sources = {
            -- adding any nvim-cmp sources here will enable them
            -- with blink.compat
            compat = {},
            default = { "lsp", "path", "snippets", "buffer" },
            cmdline = {},
        },

        keymap = { preset = "super-tab" },
    },
}
