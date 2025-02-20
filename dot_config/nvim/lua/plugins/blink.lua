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
        cmdline = {
            enabled = true,
            sources = function()
                local type = vim.fn.getcmdtype()
                -- Search forward and backward
                if type == "/" or type == "?" then
                    return { "buffer" }
                end
                -- Commands
                if type == ":" or type == "@" then
                    return { "cmdline" }
                end
                return {}
            end,
        },
        sources = {
            -- adding any nvim-cmp sources here will enable them
            -- with blink.compat
            compat = {},
            default = { "lsp", "path", "snippets", "buffer" },
        },

        keymap = { preset = "super-tab" },
    },
}
