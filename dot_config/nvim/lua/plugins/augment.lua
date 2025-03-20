return {
    "augmentcode/augment.vim",
    enabled = false,
    config = function()
        if not vim.g.vscode then
            local workspace_folders = vim.g.augment_workspace_folders or {}
            local current_dir = vim.fn.getcwd()

            table.insert(workspace_folders, current_dir)
            vim.g.augment_workspace_folders = workspace_folders
        end
    end,
}
