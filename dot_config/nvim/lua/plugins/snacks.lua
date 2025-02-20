-- local header = [[
-- ██╗  ██╗██╗         ██╗██╗   ██╗███████╗████████╗██╗███╗   ██╗
-- ██║  ██║██║         ██║██║   ██║██╔════╝╚══██╔══╝██║████╗  ██║
-- ███████║██║         ██║██║   ██║███████╗   ██║   ██║██╔██╗ ██║
-- ██╔══██║██║    ██   ██║██║   ██║╚════██║   ██║   ██║██║╚██╗██║
-- ██║  ██║██║    ╚█████╔╝╚██████╔╝███████║   ██║   ██║██║ ╚████║
-- ╚═╝  ╚═╝╚═╝     ╚════╝  ╚═════╝ ╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝]]
local header = [[
             ,----------------,              ,---------,
        ,-----------------------,          ,"        ,"|
      ,"                      ,"|        ,"        ,"  |
     +-----------------------+  |      ,"        ,"    |
     |  .-----------------.  |  |     +---------+      |
     |  |                 |  |  |     | -==----'|      |
     |  | $ sudo rm -rf / |  |  |     |         |      |
     |  | $               |  |  |/----|`---=    |      |
     |  | $ nvim .        |  |  |    /|==== ooo |      ;
     |  |                 |  |  |   / |(((( [33]|    ," 
     |  `-----------------'  |,"    | |((((     |  ,"   
     +-----------------------+      | |         |,"     
        /_)______________(_/        | +---------+       
   _______________________________   `,                  
  /  oooooooooooooooo  .o.  oooo /,   \,"-----------    
 / ==ooooooooooooooo==.o.  ooo= //   ,`\--{)B     ,"    
/_==__==========__==_ooo__ooo=_/'   /___________,"
-------------------------------]]

return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        image = { enabled = false },
        scroll = { enabled = false },
        bigfile = { enabled = true },
        dashboard = {
            preset = { header = header },
            formats = {
                header = { "%s", align = "center" },
            },
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                {
                    pane = 2,
                    icon = " ",
                    desc = "Browse Repo",
                    padding = 1,
                    key = "b",
                    action = function()
                        Snacks.gitbrowse()
                    end,
                },
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
                            height = 7,
                        },
                        {
                            icon = " ",
                            title = "Open PRs",
                            cmd = "gh pr list -L 3",
                            key = "P",
                            action = function()
                                vim.fn.jobstart("gh pr list --web", { detach = true })
                            end,
                            height = 7,
                        },
                        {
                            icon = " ",
                            title = "Git Status",
                            cmd = "git --no-pager diff --stat -B -M -C",
                            height = 10,
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
                    section = "terminal",
                    cmd = "chafa ~/Downloads/__ayase_momo_and_takakura_ken_dandadan_drawn_by_crescentbutton__sample-e20fb61afc5a39a2027da3ac4012c447-removebg-preview.png  --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
                    height = 17,
                    padding = 1,
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
