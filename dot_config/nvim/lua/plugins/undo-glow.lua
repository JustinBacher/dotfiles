return {
    "y3owk1n/undo-glow.nvim",
    event = { "VeryLazy" },
    ---@type UndoGlow.Config
    opts = {
        animation = {
            enabled = true,
            duration = 300,
            animtion_type = "spring",
            window_scoped = true,
        },
        highlights = {
            undo = { hl_color = { bg = "#693232" } },
            redo = { hl_color = { bg = "#2F4640" } },
            yank = { hl_color = { bg = "#7A683A" } },
            paste = { hl_color = { bg = "#325B5B" } },
            search = { hl_color = { bg = "#5C475C" } },
            comment = { hl_color = { bg = "#7A5A3D" } },
            cursor = { hl_color = { bg = "#793D54" } },
        },
        priority = 2048 * 3,
    },
    keys = {
        {
            "u",
            function()
                require("undo-glow").undo()
            end,
            desc = "Undo with highlight",
            noremap = true,
        },
        {
            "<C-r>",
            function()
                require("undo-glow").redo()
            end,
            desc = "Redo with highlight",
            noremap = true,
        },
        {
            "p",
            function()
                require("undo-glow").paste_below()
            end,
            desc = "Paste below with highlight",
            noremap = true,
        },
        {
            "P",
            function()
                require("undo-glow").paste_above()
            end,
            desc = "Paste above with highlight",
            noremap = true,
        },
        {
            "n",
            function()
                require("undo-glow").search_next({
                    animation = { animation_type = "strobe" },
                })
            end,
            desc = "Search next with highlight",
            noremap = true,
        },
        {
            "N",
            function()
                require("undo-glow").search_prev({
                    animation = { animation_type = "strobe" },
                })
            end,
            desc = "Search prev with highlight",
            noremap = true,
        },
        {
            "*",
            function()
                require("undo-glow").search_star({
                    animation = { animation_type = "strobe" },
                })
            end,
            desc = "Search star with highlight",
            noremap = true,
        },
        {
            "gc",
            function()
                -- This is an implementation to preserve the cursor position
                local pos = vim.fn.getpos(".")
                vim.schedule(function()
                    vim.fn.setpos(".", pos)
                end)
                return require("undo-glow").comment()
            end,
            mode = { "n", "x" },
            desc = "Toggle comment with highlight",
            expr = true,
            noremap = true,
        },
        {
            "gc",
            function()
                require("undo-glow").comment_textobject()
            end,
            mode = "o",
            desc = "Comment textobject with highlight",
            noremap = true,
        },
        {
            "gcc",
            function()
                return require("undo-glow").comment_line()
            end,
            desc = "Toggle comment line with highlight",
            expr = true,
            noremap = true,
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("TextYankPost", {
            desc = "Highlight when yanking (copying) text",
            callback = function()
                require("undo-glow").yank()
            end,
        })

        vim.api.nvim_create_autocmd("CmdLineLeave", {
            pattern = { "/", "?" },
            desc = "Highlight when search cmdline leave",
            callback = function()
                require("undo-glow").search_cmd({
                    animation = { animation_type = "fade" },
                })
            end,
        })
    end,
}
