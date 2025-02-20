return {
    "folke/tokyonight.nvim",
    opts = function()
        if vim.g.transparent_enabled then
            return {
                transparent = true,
                styles = {
                    sidebars = "transparent",
                    floats = "transparent",
                },
            }
        else
            return {}
        end
    end,
}
