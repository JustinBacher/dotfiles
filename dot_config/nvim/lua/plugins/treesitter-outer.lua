local languages = {
    "c",
    "cpp",
    "elixir",
    "fennel",
    "foam",
    "go",
    "javascript",
    "julia",
    "lua",
    "nix",
    "php",
    "python",
    "r",
    "ruby",
    "rust",
    "scss",
    "tsx",
    "typescript",
}

return {
    "Mr-LLLLL/treesitter-outer",
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = true,
    ft = languages,
    opts = {
        filetypes = languages,
        mode = { "n", "v" },
        prev_outer_key = "[{",
        next_outer_key = "]}",
    },
}