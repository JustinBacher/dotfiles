local function format_buffer() require("conform").format({ async = true, lsp_fallback = true }) end
local function ufo_peek() return require("ufo").peekFoldedLinesUnderCursor() or vim.lsp.buf.hover() end

return {
	{ "https://git.sr.ht/~whynothugo/lsp_lines.nvim", version = false, config = true },
	{ "folke/neodev.nvim",                            config = true },
	{
		"nvimtools/none-ls.nvim",
		dependencies = "nvimtools/none-ls-extras.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.completion.spell,
					require("none-ls.diagnostics.eslint"),
					require("none-ls.diagnostics.cpplint"),
					require("none-ls.formatting.jq"),
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"b0o/schemastore.nvim",
			"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
			"folke/neodev.nvim",
			"nvimtools/none-ls.nvim",
		},
		lazy = false,
		opts = {
			virtual_text = false,
			virtual_lines = true,
			signs = { active = require("plugins.configs.icons") },
			flags = { debounce_text_changes = 200 },
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			float = {
				focus = false,
				focusable = false,
				style = "minimal",
				border = "shadow",
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
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "shadow" })
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "shadow" })
		end,
		config = function(_, opts)
			vim.diagnostic.config(opts)

			local lspconfig = require("lspconfig")
			lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, opts)

			for server_name, server_config in pairs(require("plugins.configs.langs")) do
				lspconfig[server_name].setup(server_config)

				if server_name == "rust_analyzer" then
					local rust_tools_present, rust_tools = pcall(require, "rust-tools")
					if rust_tools_present then rust_tools.setup({ server = server_config }) end
				elseif server_name == "lua_ls" then
					require("neodev")
				end
			end
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
			{ "zR", function() require("ufo").openAllFolds() end,  desc = "Open all folds" },
			{ "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
			{ "zK", ufo_peek,                                      desc = "Peek Fold" },
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
					:with_pair(function(opts) return vim.tbl_contains({ "{}" }, opts.line:sub(opts.col - 1, opts.col)) end)
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
					:replace_map_cr(function(_) return "<C-c>2xi<CR><C-c>O" end),
			})
		end,
	},
	-- Lsp UI plugins

	{ "Fildo7525/pretty_hover", event = "LspAttach", config = true },
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
			{ "ga",         "<cmd>Lspsaga finder<cr>",                          desc = "Open symbol finder" },
			{ "ghi",        "<cmd>Lspsaga finder imp<cr>",                      desc = "Find all implementations" },
			{ "ghr",        "<cmd>Lspsaga finder ref<cr>",                      desc = "Find all references" },
			{ "ghd",        "<cmd>Lspsaga finder def<cr>",                      desc = "Find all definitions" },
			{ "gr",         "<cmd>Lspsaga rename<cr>",                          desc = "Rename symbol" },
			{ "gR",         "<cmd>Lspsaga rename ++project<cr>",                desc = "Rename symbol (project)" },
			{ "gd",         "<cmd>Lspsaga peek_definition<cr>",                 desc = "Peek definition" },
			{ "gD",         "<cmdLspsaga goto_definition<cr>",                  desc = "Goto definition" },
			{ "gt",         "<cmd>Lspsaga peek_type_definition<cr>",            desc = "Peek type definition" },
			{ "gT",         "<cmd>Lspsaga goto_type_definition<cr>",            desc = "Goto type definition" },
			{ "<leader>sl", "<cmd>Lspsaga show_line_diagnostics ++unfocus<cr>", desc = "Show line diagnostics" },
			{ "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<cr>",         desc = "Show cursor diagnostics" },
			{ "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<cr>",            desc = "Show buffer diagnostics" },
			{ "<leader>sw", "<cmd>TroubleToggle<cr>",                           desc = "Show workspace diagnostics" },
			{ "[d",         "<cmd>Lspsaga diagnostic_jump_prev<cr>",            desc = "Jump to previous diagnostic" },
			{ "]d",         "<cmd>Lspsaga diagnostic_jump_next<cr>",            desc = "Jump to next diagnostic" },
			{ "go",         "<cmd>Lspsaga outline<cr>",                         desc = "Show outline" },
			{ "<A-d>",      "<cmd>Lspsaga term_toggle<cr>",                     desc = "Toggle floating terminal",   mode = { "n", "t" } },
			{ "<leader>a",  "<cmd>Lspsaga code_action<cr>",                     desc = "Show code actions",          mode = { "n", "v" } },
		},
	},
}
