return {
    "RedsXDD/neopywal.nvim",
    lazy = false,
    name = "neopywal",
    priority = 1000,
    config = function()
        --- @diagnostic disable-next-line:missing-fields
        require("neopywal").setup({
            use_wallust = true,
            transparent_background = true,
            plugins = {
                snacks = { enabled = true },
                trouble = { enabled = true },
            },
        })
        vim.cmd.colorscheme("neopywal")
    end,
}
