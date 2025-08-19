-- local quote = os.execute("curl https://quoteslate.vercel.app/api/quotes/random | jq -r '.quote'")
-- local emoji = os.execute(
--     "echo 'provide an emoji for the following quote. \""
--         .. quote
--         .. "\" Your response should include only the emoji you think best fits the quote and nothing else. It is imperative that that your response be only one character in length' | ollama run llama3.2:1b"
-- )

return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        image = { enabled = false },
        scroll = { enabled = false },
        bigfile = { enabled = true },
        dashboard = {
            sections = {
                {
                    section = "terminal",
                    cmd = "chafa ~/Downloads/__ayase_momo_and_takakura_ken_dandadan_drawn_by_crescentbutton__sample-e20fb61afc5a39a2027da3ac4012c447-removebg-preview.png  --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
                    height = 17,
                    padding = 1,
                },
                {
                    pane = 2,
                    icon = " ",
                    desc = "Browse Repo",
                    padding = 1,
                    key = "b",
                    action = function()
                        Snacks.gitbrowse()
                    end,
                },
                { section = "keys", gap = 1, padding = 1 },
                function()
                    local in_git = Snacks.git.get_root() ~= nil
                    local cmds = {
                        {
                            title = "Notifications",
                            cmd = "gh notify -s -a -n5",
                            action = function()
                                vim.ui.open("https://github.com/notifications")
                            end,
                            key = "n",
                            icon = " ",
                            height = 5,
                            enabled = true,
                        },
                        {
                            title = "Open Issues",
                            cmd = "gh issue list -L 3",
                            key = "i",
                            action = function()
                                vim.fn.jobstart("gh issue list --web", { detach = true })
                            end,
                            icon = " ",
                            height = 5,
                        },
                        {
                            icon = " ",
                            title = "Open PRs",
                            cmd = "gh pr list -L 3",
                            key = "P",
                            action = function()
                                vim.fn.jobstart("gh pr list --web", { detach = true })
                            end,
                            height = 5,
                        },
                        {
                            icon = "󱖫 ",
                            title = "Git Status",
                            cmd = "git --no-pager diff --stat -B -M -C",
                            height = 7,
                        },
                    }
                    return vim.tbl_map(function(cmd)
                        return vim.tbl_extend("force", {
                            pane = 2,
                            section = "terminal",
                            enabled = in_git,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        }, cmd)
                    end, cmds)
                end,
                { section = "startup" },
                {
                    pane = 2,
                    section = "terminal",
                    icon = "󱀡 ",
                    title = "Quote",
                    height = 4,
                    cmd = "gh inspire",
                    indent = 2,
                },
            },
        },
        explorer = { enabled = false },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        lazygit = { enabled = true },
    },
    -- stylua: ignore
    keys = {
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    },
}
