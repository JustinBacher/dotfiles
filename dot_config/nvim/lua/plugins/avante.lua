-- ACP agents, run through their adapters installed as global Mise npm tools.
-- They use the subscription logins already on this machine: ChatGPT in ~/.codex and Claude
-- in ~/.claude. A provider appears only when its login and adapter are available. Avante
-- passes the adapter only PATH and the env table below, so no API key from the shell reaches it.
local acp_providers = (function()
    local providers = {}
    local home = os.getenv("HOME")
    local codex_acp = vim.fn.exepath("codex-acp")
    local codex = vim.fn.exepath("codex")
    local claude_acp = vim.fn.exepath("claude-agent-acp")

    if vim.fn.filereadable(home .. "/.codex/auth.json") == 1 and codex_acp ~= "" and codex ~= "" then
        providers["codex"] = {
            command = codex_acp,
            args = {},
            env = {
                HOME = home,
                NODE_NO_WARNINGS = "1",
                CODEX_PATH = codex,
            },
        }
    end
    if vim.fn.filereadable(home .. "/.claude/.credentials.json") == 1 and claude_acp ~= "" then
        providers["claude-code"] = {
            command = claude_acp,
            args = {},
            env = { HOME = home, NODE_NO_WARNINGS = "1" },
        }
    end
    return providers
end)()

return {
    "yetone/avante.nvim",
    enabled = true,
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
        -- Default to an ACP agent: Codex if logged in, else Claude. Switch with :AvanteSwitchProvider.
        provider = acp_providers.codex and "codex" or "claude-code",
        providers = {
            openai = {
                endpoint = "https://api.openai.com/v1",
                model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
                timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
                extra_request_body = {
                    temperature = 0,
                    max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
                    -- reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
                },
            },
        },
        acp_providers = acp_providers,
        behaviour = {
            --- ... existing behaviours
            enable_cursor_planning_mode = true, -- enable cursor planning mode!
        },
        -- Disabled: it runs in Docker, defaults to an OpenAI key, and its settings use the old
        -- format (host_mount and friends). Re-enable only after moving llm/embed to the current format.
        rag_service = {
            enabled = false,
        },
        opts = {},
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    config = function(_, opts)
        require("avante").setup(opts)
        -- The ACP selectors need the sidebar window. With the sidebar closed they crash, so
        -- open it first. focus() does nothing when no sidebar exists yet, and the selector then
        -- warns instead of crashing.
        -- Opening the sidebar starts an ACP connect. Upstream races when a second connect starts
        -- before the first finishes, and then the model switch fails with "Session not found".
        -- Three guards keep one connect and its session attached to the chat:
        --   connecting(): a connect is starting (client not ready, started under 10s ago)
        --   handle_submit: skip a second connect while one is starting
        --   reload_chat_history: keep the chat table, since the connect saves its session id into it
        --   open_acp_picker: wait until the chat's session belongs to the client
        local Sidebar = require("avante.sidebar")
        local function connecting(self)
            local started = self.acp_connect_started
            local ready = self.acp_client and self.acp_client.config_options
            return started and not ready and vim.uv.now() - started < 10000
        end
        local submit = Sidebar.handle_submit
        Sidebar.handle_submit = function(self, request, ...)
            if request == "" then
                if connecting(self) then return end
                self.acp_connect_started = vim.uv.now()
            end
            return submit(self, request, ...)
        end
        local reload = Sidebar.reload_chat_history
        Sidebar.reload_chat_history = function(self)
            if self.chat_history and connecting(self) then return end
            return reload(self)
        end
        local function open_acp_picker(pick)
            require("avante.api").focus()
            local config = require("avante.config")
            local sidebar = require("avante").get(false)
            if not sidebar or not config.acp_providers[config.provider] then return pick() end
            -- Ready means the chat's session belongs to this client. The saved id can be stale
            -- (a failed session/load) until the new session is saved.
            local function ready()
                local client = sidebar.acp_client
                local sid = sidebar.chat_history and sidebar.chat_history.acp_session_id
                return client and client.config_options and sid and client.active_session_ids[sid]
            end
            if ready() then return pick() end
            local waited = 0
            local timer = vim.uv.new_timer()
            timer:start(100, 100, vim.schedule_wrap(function()
                waited = waited + 100
                if ready() or waited >= 10000 then
                    timer:stop()
                    timer:close()
                    pick()
                end
            end))
        end
        vim.keymap.set("n", "<leader>aM", function()
            open_acp_picker(function() require("avante.api").select_acp_model() end)
        end, { desc = "avante: select ACP model" })
        vim.keymap.set("n", "<leader>am", function()
            open_acp_picker(function() require("avante.api").select_acp_mode() end)
        end, { desc = "avante: select ACP mode" })
        -- Upstream bug: switching provider keeps the old agent's ACP client, so the ACP pickers keep
        -- listing its models. Drop the client and the chat's session ID on a real switch. Both the
        -- switch command and the non-ACP picker go through providers.refresh, so wrap that.
        local providers = require("avante.providers")
        local refresh = providers.refresh
        providers.refresh = function(provider_name, ...)
            local sidebar = require("avante").get(false)
            if sidebar and provider_name ~= require("avante.config").provider then
                sidebar:stop_acp_client()
                if sidebar.chat_history then sidebar.chat_history.acp_session_id = nil end
            end
            return refresh(provider_name, ...)
        end
        -- Switch between ACP providers (codex, claude-code) and the others. Session only; add --save to persist.
        vim.keymap.set("n", "<leader>ap", function() vim.cmd("AvanteSwitchProvider") end, {
            desc = "avante: switch provider",
        })
    end,
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        -- Required by avante's commands.lua (require "mega.cmdparse"). Declared per upstream README.
        { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
        --- The below dependencies are optional,
        "nvim-mini/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
    keys = function(_, keys)
        ---@type avante.Config
        local opts = {
            mappings = {
                ask = "<leader>ua", -- ask
                edit = "<leader>ue", -- edit
                refresh = "<leader>ur", -- refresh
            },
        }

        local mappings = {
            {
                ---@diagnostic disable-next-line: undefined-field
                opts.mappings.ask,
                function()
                    require("avante.api").ask()
                end,
                desc = "avante: ask",
                mode = { "n", "v" },
            },
            {
                ---@diagnostic disable-next-line: undefined-field
                opts.mappings.refresh,
                function()
                    require("avante.api").refresh()
                end,
                desc = "avante: refresh",
                mode = "v",
            },
            {
                ---@diagnostic disable-next-line: undefined-field
                opts.mappings.edit,
                function()
                    require("avante.api").edit()
                end,
                desc = "avante: edit",
                mode = { "n", "v" },
            },
        }
        mappings = vim.tbl_filter(function(m)
            return m[1] and #m[1] > 0
        end, mappings)
        return vim.list_extend(mappings, keys)
    end,
}
