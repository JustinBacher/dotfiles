return {
	{
		"andersevenrud/nvim_context_vt",
		event = "LazyFile",
		opts = { prefix = "" },
		config = function(_, opts)
			require('nvim_context_vt').setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		event = "LazyFile",
		lazy = vim.fn.argc(-1) == 0,
		main = "nvim-treesitter.configs",
		cmd = {
			"TSUpdate",
			"TSUpdateSync",
			"TSUpdate",
			"TSInstallInfo",
			"TSInstall",
			"TSEnable",
			"TSDisable",
			"TSBufEnable",
			"TSBufDisable",
			"TSModuleInfo",
		},
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
			vim.filetype.add({ pattern = { [".*/hypr/.*%.conf"] = "hyprlang" } })
			vim.filetype.add({
				extension = {
					tmpl = "gotmpl",
				},
				pattern = {
					[".*.%.toml"] = "toml",
					[".*.%.lua"] = "lua"
				}
			})
		end,
		dependencies = { { "nushell/tree-sitter-nu", build = ":TSUpdate nu" } },
		build = ":TSUpdate",
		--- @diagnostic disable-next-line: missing-fields
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"gotmpl",
				"html",
				"hyprlang",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			},
			auto_install = true,
			sync_install = true,
			indent = { enable = true },
			highlight = { enable = true, disable = { "c", "ruist" } },
			disable = function(lang, buf) ---@diagnostic disable-line: unused-local
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				return ok and stats and stats.size > 100 * 1024 -- 100kb
			end,
			additional_vim_regex_highlighting = false,
		},
	},
}
