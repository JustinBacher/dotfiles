local function format_buffer() require("conform").format({ async = true, lsp_fallback = true }) end
local function ufo_peek() return require("ufo").peekFoldedLinesUnderCursor() or vim.lsp.buf.hover() end

return {
	{ "https://git.sr.ht/~whynothugo/lsp_lines.nvim", enabled = false, version = false, config = true },
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		opts = {
			preset = "classic",
			use_icons_from_diagnostic = true,
			multiple_diag_under_cursor = true,
			show_all_diags_on_cursorline = false,
			multilines = {
				-- Enable multiline diagnostic messages
				enabled = true,
				-- Always show messages on all lines for multiline diagnostics
				always_show = true,
			},
		},
	},
	{
		"ray-x/navigator.lua",
		dependencies = {
			{ "ray-x/guihua.lua", build = "cd lua/fzy && make" },
			{ "neovim/nvim-lspconfig" },
		},
	},
	{
		"aznhe21/actions-preview.nvim",
		opts = {
			highlight_command = function() return { require("actions-preview.highlight").delta() } end,
			telescope = {
				sorting_strategy = "ascending",
				layout_strategy = "vertical",
				layout_config = {
					width = 0.8,
					height = 0.9,
					prompt_position = "top",
					preview_cutoff = 20,
					preview_height = function(_, _, max_lines) return max_lines - 15 end,
				},
			},
		},
		config = function(opts)
			opts.highlight_command = opts.highlight_command()
			require("actions-preview").setup(opts)
		end,
		keys = {
			{
				"<leader>gf",
				function() require("actions-preview").code_actions() end,
				desc = "Code actions",
			},
		},
	},
	-- {
	-- 	"folke/lazydev.nvim",
	-- 	ft = "lua", -- only load on lua files
	-- 	opts = {
	-- 		library = {
	-- 			"lazy.nvim",
	-- 			{ path = "wezterm-types", mods = { "wezterm" } },
	-- 		},
	-- 	},
	-- },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"b0o/schemastore.nvim",
			-- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
			"folke/lazydev.nvim",
		},
		lazy = false,
		opts = {
			virtual_text = false, -- TODO: May want to add this back in idk
			virtual_lines = true,
			signs = { active = require("plugins.configs.icons") },
			flags = { debounce_text_changes = 200 },
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			diagnostics = {
				update_in_insert = true,
			},
			servers = {},
			float = {
				focus = false,
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		},
		init = function()
			for name, sign in pairs(require("plugins.configs.icons").lsp.diagnostics) do
				vim.fn.sign_define(name, { texthl = name, text = sign, numhl = "" })
			end
			vim.lsp.set_log_level("error")
			-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "shadow" })
			-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "shadow" })
		end,
		config = function(_, opts)
			vim.diagnostic.config(opts)

			local lspconfig = require("lspconfig")
			lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, opts)

			for server, config in pairs(require("plugins.configs.langs")) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)

				if server == "lua_ls" then require("lazydev") end
			end
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		opts = {
			default_settings = {
				["rust-analyzer"] = {
					diagnostics = { enable = false },
					checkOnSave = { enable = false },
					["rust-analyzer.cargo.extraEnv"] = {
						RUSTFLAGS = "--cfg rust_analyzer",
					},
					["rust-analyzer.diagnostics.disabled"] = {
						"unlinked-file",
					},
				},
			},
		},
		lazy = false, -- This plugin is already lazy
		ft = "rust",
		config = function()
			local mason_registry = require("mason-registry")
			local codelldb = mason_registry.get_package("codelldb")
			local extension_path = codelldb:get_install_path() .. "/extension/"
			local codelldb_path = extension_path .. "adapter/codelldb"
			local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
			if string.find(vim.uv.os_uname().sysname, "Linux") then
				liblldb_path = extension_path .. "lldb/lib/liblldb.so"
			end
			local cfg = require("rustaceanvim.config")

			vim.g.rustaceanvim = {
				dap = { adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path) },
			}
		end,
	},

	-- Formatting

	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = "ConformInfo",
		opts = {
			formatters_by_ft = {
				lua = { "luaformatter", "stylua" },
				nix = { "alejandra" },
				python = { "isort", "black" },
				cpp = { "astyle" },
			},
			formatters = {
				rustfmt = {
					options = { default_edition = "2024" },
				},
			},
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
		},
		keys = {
			{ "<leader>bf", format_buffer, desc = "Format buffer" },
		},
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "LazyFile",
		init = function()
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
		keys = {
			{ "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
			{ "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
			{ "zK", ufo_peek, desc = "Peek Fold" },
		},
		opts = {
			provider_selector = function() return { "lsp", "indent" } end,
		},
	},
	{
		"windwp/nvim-autopairs",
		opts = { enable_check_bracket_pairs = false, fast_wrap = {} },
		build = function()
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")

			npairs.add_rules({
				Rule(" ", " ", "lua")
					:with_pair(
						function(opts) return vim.tbl_contains({ "{}" }, opts.line:sub(opts.col - 1, opts.col)) end
					)
					:with_move(cond.none())
					:with_cr(cond.none())
					:with_del(function(opts)
						local col = vim.api.nvim_win_get_cursor(0)[2]
						return vim.tbl_contains({ "{ }" }, opts.line:sub(col - 1, col + 2))
					end),
			})
			-- For each pair of brackets we will add another rule
			npairs.add_rules({
				-- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
				Rule("{ ", " }", "lua")
					:with_pair(cond.none())
					:with_move(function(opts) return opts.char == "}" end)
					:with_del(cond.none())
					:use_key("}")
					-- Removes the trailing whitespace that can occur without this
					:replace_map_cr(
						function(_) return "<C-c>2xi<CR><C-c>O" end
					),
			})
		end,
	},
	-- Lsp UI plugins

	{
		"Fildo7525/pretty_hover",
		event = "LspAttach",
		config = true,
		keys = {
			{ "<leader>h", function() require("pretty_hover").hover() end, desc = "Code hover" },
		},
	},
	{
		"glepnir/lspsaga.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		event = "LazyFile",
		opts = {
			implement = { enable = true, lang = { "rust" } },
			lightbulb = { sign = false },
			code_action = { extend_gitsigns = true },
		},
		keys = {
			{ "ga", "<cmd>Lspsaga finder<cr>", desc = "Open symbol finder" },
			{ "ghi", "<cmd>Lspsaga finder imp<cr>", desc = "Find all implementations" },
			{ "ghr", "<cmd>Lspsaga finder ref<cr>", desc = "Find all references" },
			{ "ghd", "<cmd>Lspsaga finder def<cr>", desc = "Find all definitions" },
			{ "gr", "<cmd>Lspsaga rename ++project<cr>", desc = "Rename symbol (project)" },
			{ "gd", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
			{ "gD", "<cmdLspsaga goto_definition<cr>", desc = "Goto definition" },
			{ "gt", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek type definition" },
			{ "gT", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Goto type definition" },
			{ "<leader>sl", "<cmd>Lspsaga show_line_diagnostics ++unfocus<cr>", desc = "Show line diagnostics" },
			{ "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<cr>", desc = "Show cursor diagnostics" },
			{ "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<cr>", desc = "Show buffer diagnostics" },
			{ "<leader>sw", "<cmd>TroubleToggle<cr>", desc = "Show workspace diagnostics" },
			{ "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Jump to previous diagnostic" },
			{ "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Jump to next diagnostic" },
			{ "go", "<cmd>Lspsaga outline<cr>", desc = "Show outline" },
			{ "<A-d>", "<cmd>Lspsaga term_toggle<cr>", desc = "Toggle floating terminal", mode = { "n", "t" } },
			{ "<leader>c", "<cmd>Lspsaga code_action<cr>", desc = "Show code actions", mode = { "n", "v" } },
		},
	},
}
