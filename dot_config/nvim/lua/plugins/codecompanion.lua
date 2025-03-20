-- Copied from https://github.com/Matt-FTW/dotfiles

local prefix = "<leader>a"
local user = vim.env.USER or "User"

local providers = {
    chat = "gemini",
    inline = "gemini",
    agent = "gemini",
}

return {
    {
        "olimorris/codecompanion.nvim",
        enabled = false,
        dependencies = { "Davidyz/VectorCode" },
        cmd = {
            "CodeCompanion",
            "CodeCompanionAdd",
            "CodeCompanionActions",
            "CodeCompanionToggle",
            "CodeCompanionAdd",
            "CodeCompanionChat",
        },
        config = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "CodeCompanionChatAdapter",
                callback = function(args)
                    if args.data.adapter == nil or vim.tbl_isempty(args.data) then
                        return
                    end
                    vim.g.llm_name = args.data.adapter.name
                end,
            })

            require("codecompanion").setup({
                adapters = {
                    deepseek_coder = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            name = "deepseek_coder",
                            schema = { model = { default = "deepseek-coder" } },
                        })
                    end,
                    ollama_chat = function()
                        return require("codecompanion.adapters").extend("ollama", {
                            name = providers.chat,
                            schema = { model = { default = providers.chat } },
                        })
                    end,
                    ollama_inline = function()
                        return require("codecompanion.adapters").extend("ollama", {
                            name = providers.inline,
                            schema = { model = { default = providers.chat } },
                        })
                    end,
                    ollama_agent = function()
                        return require("codecompanion.adapters").extend("ollama", {
                            name = providers.agent,
                            schema = { model = { default = providers.chat } },
                        })
                    end,
                    deepseek_r1 = function()
                        return require("codecompanion.adapters").extend("ollama", {
                            name = "deepseek_r1",
                            schema = { model = { default = "deepseek-r1:14b" } },
                        })
                    end,
                    openai = function()
                        return require("codecompanion.adapters").extend("openai", {
                            env = {
                                api_key = 'cmd:keeper get --format=json "Ld_1ceHcO46K_yk53sdo9A" | jq -r \'.custom[] | select(.label == "OpenAI API Key") | .value[0]\'',
                            },
                        })
                    end,
                    gemini = function()
                        return require("codecompanion.adapters").extend("gemini", {
                            env = {
                                api_key = "AIzaSyB7pJS4VPBBPszDj9zViA_LetF5nU7xyBk",
                            },
                        })
                    end,
                },
                strategies = {
                    chat = {
                        adapter = "gemini",
                        slash_commands = {
                            codebase = require("vectorcode.integrations").codecompanion.chat.make_slash_command(),
                        },
                        tools = {
                            vectorcode = {
                                description = "Run VectorCode to retrieve the project context.",
                                callback = require("vectorcode.integrations").codecompanion.chat.make_tool({
                                    max_num = 2,
                                    default_num = 1,
                                }),
                            },
                        },
                        roles = {
                            llm = "  CodeCompanion",
                            user = " " .. user:sub(1, 1):upper() .. user:sub(2),
                        },
                        keymaps = {
                            close = { modes = { n = "q", i = "<C-c>" } },
                            stop = { modes = { n = "<C-c>" } },
                            send = { modes = { n = "<CR>", i = "<CR>" } },
                        },
                    },
                    agent = { adapter = "gemini" },
                    inline = { adapter = "gemini" },
                },
                display = {
                    chat = { show_settings = true, render_headers = false },
                },
            })
        end,
        keys = {
            { prefix .. "a", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
            { prefix .. "c", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "New Chat" },
            { prefix .. "A", "<cmd>CodeCompanionAdd<cr>", mode = "v", desc = "Add Code" },
            { prefix .. "i", "<cmd>CodeCompanion<cr>", desc = "Inline Prompt" },
            { prefix .. "q", "<cmd>CodeCompanionToggle<cr>", desc = "Toggle Chat" },
        },
    },
    {
        "folke/which-key.nvim",
        ["opts.spec"] = {
            { prefix, group = "ai", icon = "󱚦 ", mode = { "n", "v" } },
        },
    },
    {
        "folke/edgy.nvim",
        optional = true,
        opts = function(_, opts)
            opts.right = opts.right or {}
            table.insert(opts.right, {
                ft = "codecompanion",
                title = "CodeCompanion",
                size = { width = 70 },
            })
        end,
    },
}
