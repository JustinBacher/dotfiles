local function live_grep_from_project_git_root()
	local function is_git_repo()
		vim.fn.system("git rev-parse --is-inside-work-tree")
		return vim.v.shell_error == 0
	end

	require("telescope.builtin").live_grep({
		cwd = is_git_repo() and vim.fn.fnamemodify(vim.fn.finddir(".git", ".;"), ":h") or nil,
	})
end

return {
	{ "windwp/nvim-autopairs", config = true },
	{ "echasnovski/mini.ai", event = "LazyFile", config = true },
	{ "tenxsoydev/karen-yank.nvim", event = "LazyFile", config = true },
	{
		"Shatur/neovim-session-manager",
		event = "LazyFile",
		opts = { autoload_mode = false },
		cmd = "SessionManager",
		build = function()
			-- Auto save session
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				callback = function()
					local session_manager = require("session_manager")
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						-- Don't save while there's any 'nofile' buffer open.
						if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "nofile" then return end
					end
					session_manager.save_current_session()
				end,
			})
		end,
	},
	{
		"monaqa/dial.nvim",
		keys = {
			{ "<C-a>", "<Plug>(dial-increment)" },
			{ "<C-x>", "<Plug>(dial-decrement)" },
			{ "g<C-a>", "g<Plug>(dial-increment)" },
			{ "g<C-x>", "g<Plug>(dial-decrement)" },
			{ "<C-a>", "<Plug>(dial-increment)", mode = "v" },
			{ "<C-x>", "<Plug>(dial-decrement)", mode = "v" },
			{ "g<C-a>", "g<Plug>(dial-increment)", mode = "v" },
			{ "g<C-x>", "g<Plug>(dial,-decrement)", mode = "v" },
		},
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				---@type table<( Augend | AugendConstant )>
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.date.alias["%Y-%m-%d"],
					augend.date.alias["%m/%d"],
					augend.date.alias["%H:%M"],
					augend.semver.alias.semver,
					augend.constant.alias.bool,
					augend.constant.new({ elements = { "on", "off" } }),
					augend.constant.new({ elements = { "on", "off" } }),
					augend.constant.new({ elements = { "On", "Off" } }),
					augend.constant.new({ elements = { "ON", "OFF" } }),
					augend.constant.new({ elements = { "start", "stop" } }),
					augend.constant.new({ elements = { "Start", "Stop" } }),
					augend.constant.new({ elements = { "START", "STOP" } }),
				},
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			window = {
				border = "shadow",
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-telescope/telescope-media-files.nvim" },
		cmd = "Telescope",
		keys = {
			{ "<leader><space>", "<Cmd>Telescope find_files<CR>", desc = "Find Files (Root Dir)" },
			{ "<leader>/", live_grep_from_project_git_root, desc = "Grep (Root Dir)" },
			{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Telescope Buffers" },
			{
				"<leader>ff",
				function() require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir() }) end,
				desc = "Find Files (cwd)",
			},
		},
		opts = {
			pickers = {
				find_files = { hidden = true },
				live_grep = { hidden = true },
			},
		},
		build = function()
			local load = require("telescope").load_extension
			load("media_files")
			load("noice")
		end,
		config = true,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		keys = {
			{ "<A-k>", function() vim.lsp.buf.code_action() end, "Open code actions" },
		},
		config = function()
			require("telescope").setup({
				extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown({}) } },
			})
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"ziontee113/icon-picker.nvim",
		keys = {
			{ "<leader>if", "<cmd>IconPickerNormal<cr>", desc = "Find Icon" },
			{ "<leader>iy", "<cmd>IconPickerYank<cr>", desc = "Yank Icon" },
		},
		opts = { disable_legacy_commands = true },
	},
	{
		"echasnovski/mini.surround",
		event = "LazyFile",
		opts = {
			mappings = {
				add = "gsa", -- Add surrounding in Normal and Visual modes
				delete = "gsd", -- Delete surrounding
				find = "gsf", -- Find surrounding (to the right)
				find_left = "gsF", -- Find surrounding (to the left)
				highlight = "gsh", -- Highlight surrounding
				replace = "gsr", -- Replace surrounding
				update_n_lines = "gsn", -- Update `n_lines`
			},
			custom_surroundings = {
				["<"] = { output = { left = "<", right = ">" } },
			},
		},
	},
}
