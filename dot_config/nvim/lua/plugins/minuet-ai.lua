return {
    "milanglacier/minuet-ai.nvim",
    opts = {
        n_completions = 1,
        provider = "openai_fim_compatible",
        provider_options = {
            openai_fim_compatible = {
                api_key = "TERM",
                name = "ollama",
                end_point = "http://127.0.0.1:4096/v1/completions",
                model = vim.g.ollama_model,
            },
        },
    },
}
