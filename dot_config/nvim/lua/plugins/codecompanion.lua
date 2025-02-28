-- Copied from https://github.com/Matt-FTW/dotfiles

local prefix = "<leader>a"
local user = vim.env.USER or "User"
local cc = "CodeCompanion"

local providers = {
    chat = "deepseek_coder:6.7b",
    inline = "deepseek_coder:6.7b",
    agent = "deepseek_coder:6.7b",
}

vim.api.nvim_create_autocmd("User", {
    pattern = cc .. "ChatAdapter",
    callback = function(args)
        if args.data.adapter == nil or vim.tbl_isempty(args.data) then
            return
        end
        vim.g.llm_name = args.data.adapter.name
    end,
})

return {
    {
        "olimorris/codecompanion.nvim",
        cmd = { cc, cc .. "Actions", cc .. "Toggle", cc .. "Add", cc .. "Chat" },
        opts = {
            adapters = {
                deepseek_coder = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        name = "deepseek_coder",
                        schema = {
                            model = {
                                default = "deepseek-coder",
                            },
                        },
                    })
                end,
                deepseek_r1 = function()
                    return require("codecompanion.adapters").extend("ollama", {
                        name = "deepseek_r1",
                        schema = {
                            model = {
                                default = "deepseek-r1:14b",
                            },
                        },
                    })
                end,
                openai = function()
                    return require("codecompanion.adapters").extend("openai", {
                        env = {
                            api_key = 'cmd:keeper get --format=json "Ld_1ceHcO46K_yk53sdo9A" | jq -r \'.custom[] | select(.label == "OpenAI API Key") | .value[0]\'',
                        },
                    })
                end,
            },
            strategies = {
                chat = {
                    adapter = providers.chat,
                    roles = {
                        llm = "  " .. cc,
                        user = " " .. user:sub(1, 1):upper() .. user:sub(2),
                    },
                    keymaps = {
                        close = { modes = { n = "q", i = "<C-c>" } },
                        stop = { modes = { n = "<C-c>" } },
                    },
                },
                inline = { adapter = providers.inline },
                agent = { adapter = providers.agent },
            },
            display = {
                chat = { show_settings = true, render_headers = false },
            },
        },
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
