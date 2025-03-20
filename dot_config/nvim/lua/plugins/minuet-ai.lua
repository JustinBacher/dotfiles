return {
    "milanglacier/minuet-ai.nvim",
    opts = {
        n_completions = 1,
        provider = "openai_fim_compatible",
        context_window = 512,
        provider_options = {
            openai_fim_compatible = {
                api_key = "TERM",
                name = "ollama",
                end_point = "http://127.0.0.1:11434/v1/completions",
                model = vim.g.ollama_model,
                optional = {
                    max_tokens = 56,
                    top_p = 0.9,
                },
                -- template = {
                --     prompt = function(pref, suff)
                --         local has_vc, vectorcode_config = pcall(require, "vectorcode.config")
                --         local vectorcode_cacher = nil
                --         local prompt_message = ""
                --
                --         if has_vc then
                --             vectorcode_cacher = vectorcode_config.get_cacher_backend()
                --             for _, file in ipairs(vectorcode_cacher.query_from_cache(0)) do
                --                 prompt_message = prompt_message .. "<|file_sep|>" .. file.path .. "\n" .. file.document
                --             end
                --         end
                --
                --         return prompt_message
                --             .. "<|fim_prefix|>"
                --             .. pref
                --             .. "<|fim_suffix|>"
                --             .. suff
                --             .. "<|fim_middle|>"
                --     end,
                --     suffix = false,
                -- },
            },
        },
    },
}
