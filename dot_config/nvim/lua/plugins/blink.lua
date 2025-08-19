local kind_icons = {
    -- LLM Provider icons
    claude = "󰋦",
    openai = "󱢆",
    codestral = "󱎥",
    gemini = "",
    Groq = "",
    Openrouter = "󱂇",
    Ollama = "󰳆",
    ["Llama.cpp"] = "󰳆",
    Deepseek = "",
}

return {
    {
        "saghen/blink.cmp",
        dependencies = {
            -- "milanglacier/minuet-ai.nvim",
            "Kaiser-Yang/blink-cmp-avante",
            { "saghen/blink.compat", version = "*", lazy = true, config = true },
            "rafamadriz/friendly-snippets",
        },
        version = "1.*",
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
                default = { "avante", "lsp", "path", "snippets", "buffer" },
                providers = {
                    avante = {
                        module = "blink-cmp-avante",
                        name = "Avante",
                        opts = {
                            -- options for blink-cmp-avante
                        },
                    },
                    -- minuet = {
                    --     name = "minuet",
                    --     module = "minuet.blink",
                    --     score_offset = 100,
                    -- },
                },
            },
            keymap = {
                preset = "super-tab",
                ["<Tab>"] = {
                    require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
                    require("lazyvim.util.cmp").map({ "snippet_forward", "ai_accept" }),
                    "fallback",
                },
            },
            appearance = {
                nerd_font_variant = "mono",
                kind_icons = kind_icons,
            },
        },
    },
}
