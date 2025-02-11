return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    adapters = {
        qwen_coder = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "qwen_coder", -- Give this adapter a different name to differentiate it from the default ollama adapter
                schema = {
                    model = { default = "qwen2.5-coder:1.5b" },
                    num_ctx = { default = 16384 },
                    num_predict = { default = -1 },
                },
            })
        end,
    },
}
