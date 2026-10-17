local prefix = "<leader>a"
local user = vim.env.USER or "User"

return {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    opts = {},
    cmd = {
        "CodeCompanion",
        "CodeCompanionAdd",
        "CodeCompanionActions",
        "CodeCompanionToggle",
        "CodeCompanionAdd",
        "CodeCompanionChat",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "ravitemer/mcphub.nvim",
    },
}
