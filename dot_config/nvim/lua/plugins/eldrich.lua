return {
    "eldritch-theme/eldritch.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        transparent = vim.g.transparent_enabled or false,
        palette = "darker",
        styles = {
            LspInlayHint = { italic = true, bg = nil },
            LspReferenceText = { italic = true },
            LspReferenceRead = { italic = true },
            LspReferenceWrite = { italic = true },
            LspSignatureActiveParameter = { italic = true, bold = false },
        },
    },
}
