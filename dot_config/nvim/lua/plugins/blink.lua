return {
    {
        "saghen/blink.compat",
        -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
        version = "*",
        -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
        lazy = true,
        -- make sure to set opts so that lazy.nvim calls blink.compat's setup
        config = true,
    },
    {
        "saghen/blink.cmp",
        opts_extend = {
            "sources.completion.enabled_providers",
            "sources.compat",
            "sources.default",
        },
        dependencies = {
            {
                "tzachar/cmp-ai",
                dependencies = "nvim-lua/plenary.nvim",
                config = function()
                    local cmp_ai = require("cmp_ai.config")

                    cmp_ai:setup({
                        max_lines = 100,
                        provider = "Ollama",
                        provider_options = {
                            model = "deepseek-coder",
                            auto_unload = false, -- Set to true to automatically unload the model when
                            -- exiting nvim.
                        },
                        notify = true,
                        notify_callback = function(msg)
                            vim.notify(msg)
                        end,
                        run_on_every_keystroke = true,
                        ignored_file_types = {
                            -- default is not to ignore
                            -- uncomment to ignore in lua:
                            -- lua = true
                        },
                    })
                end,
            },
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
                compat = { "cmp-ai" },
                default = { "cmp-ai", "lsp", "path", "snippets", "buffer" },
            },

            keymap = { preset = "super-tab" },
        },
    },
}
