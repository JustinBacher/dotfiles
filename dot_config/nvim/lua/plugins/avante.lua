return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
        provider = "ollama",
        auto_suggestions_provider = "ollama",
        cursor_applying_provider = "ollama",
        ollama = {
            model = "llama3.2",
        },
        openai = {
            endpoint = "https://api.openai.com/v1",
            model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
            timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
            temperature = 0,
            max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
            --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
        },
        behaviour = {
            --- ... existing behaviours
            enable_cursor_planning_mode = true, -- enable cursor planning mode!
        },
        rag_service = {
            enabled = true, -- Enables the RAG service
            host_mount = os.getenv("HOME"), -- Host mount path for the rag service
            provider = "ollama", -- The provider to use for RAG service (e.g. openai or ollama)
            llm_model = "llama3.2", -- The LLM model to use for RAG service
            embed_model = "hf.co/awhiteside/CodeRankEmbed-Q5_K_M-GGUF", -- The embedding model to use for RAG service
            endpoint = "http://localhost:11434", -- The API endpoit for RAG service
        },
        opts = {},
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick", -- for file_selector provider mini.pick
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
