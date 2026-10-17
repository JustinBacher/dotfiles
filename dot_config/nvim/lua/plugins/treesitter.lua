return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            -- Add "wgsl"  to the list of installed parsers
            vim.list_extend(opts.ensure_installed, { "wgsl" })
        end,
    },
}
