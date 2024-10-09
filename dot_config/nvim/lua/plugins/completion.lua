local function next_completion(cmp, luasnip)
	return function(fallback)
		if cmp.visible() then
			cmp.select_next_item()
		elseif luasnip.expand_or_jumpable() then
			vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
		else
			fallback()
		end
	end
end

local function prev_completion(cmp, luasnip)
	return function(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		elseif luasnip.jumpable(-1) then
			vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
		else
			fallback()
		end
	end
end

return {
	{ "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
	{
		"tzachar/cmp-ai",
		version = false,
		enabled = false,
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("cmp_ai.config"):setup({
				provider = "Ollama",
				max_lines = 100,
				provider_options = { model = "codellama" },
				notify = true,
				-- notify_callback = function(msg) require("fidget").notify(msg) end,
				run_on_every_keystroke = true,
			})
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
		config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
		build = "make install_jsregexp",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-cmdline",
			"windwp/nvim-autopairs",
			"onsails/lspkind-nvim",
			"roobert/tailwindcss-colorizer-cmp.nvim",
			"L3MON4D3/LuaSnip",
			-- "tzachar/cmp-ai",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			local icons = require("plugins.configs.icons").lsp
			-- local compare = require("cmp.config.compare")

			cmp.setup({
				enabled = true,
				experimental = { ghost_text = true },
				snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
				completion = { keyword_length = 1 },
				preselect = cmp.PreselectMode.Item,
				performance = {
					debounce = 0,
					throttle = 0,
					fetching_timeout = 500,
					confirm_resolve_timeout = 80,
					async_budget = 1,
					max_view_entries = 200,
				},
				sources = cmp.config.sources({
					-- { name = "cmp_ai", max_item_count = 1, group_index = 1 },
					{ name = "luasnip", max_item_count = 3, group_index = 1 },
					{ name = "nvim_lsp", max_item_count = 10, group_index = 1 },
					{ name = "nvim_lsp_signature_help", group_index = 1 },
					{ name = "nvim_lua", group_index = 1 },
					{ name = "path", group_index = 3 },
				}, {
					{ name = "buffer", keyword_length = 2, max_item_count = 5, group_index = 2 },
				}),
				-- sorting = {
				-- 	priority_weight = 2,
				-- 	comparators = {
				-- 		require("cmp_ai.compare"),
				-- 		compare.offset,
				-- 		compare.exact,
				-- 		compare.score,
				-- 		compare.recently_used,
				-- 		compare.kind,
				-- 		compare.sort_text,
				-- 		compare.length,
				-- 		compare.order,
				-- 	},
				-- },
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, item)
						local kind = lspkind.cmp_format({
							mode = "symbol_text",
							maxwidth = 30,
							ellipsis_char = "",
							symbol_map = icons.kind,
						})(entry, item)

						local strings = vim.split(kind.kind, "%s", { trimempty = true })
						kind.kind = " " .. (strings[1] or "") .. " "
						kind.abbr = kind.abbr
						kind.menu = icons.menu[entry.source.name] or "" or strings[2]
						return kind
					end,
				},
				window = {
					completion = {
						border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
						winhighlight = "Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None",
						col_offset = 0,
					},
					documentation = cmp.config.window.bordered({
						winhighlight = "Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None",
					}),
				},
				mapping = {
					["<C-f>"] = cmp.mapping.scroll_docs(-4),
					["<C-b>"] = cmp.mapping.scroll_docs(4),
					["<C-l>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
					["<C-j>"] = next_completion(cmp, luasnip),
					["<C-k>"] = prev_completion(cmp, luasnip),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<Esc>"] = function(fallback)
						cmp.mapping.close()(fallback)
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
					end,
				},
			})

			cmp.setup.cmdline({ "/", "?" }, { ---@diagnostic disable-line: param-type-mismatch, missing-fields
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "buffer" } },
			})

			cmp.setup.cmdline(":", { ---@diagnostic disable-line: param-type-mismatch, missing-fields
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
				matching = { disallow_symbol_nonprefix_matching = false }, ---@diagnostic disable-line: missing-fields
			})

			local presentAutopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
			if presentAutopairs then
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
			end

			local hl = vim.api.nvim_set_hl
			hl(0, "PmenuSel", { bg = "NONE", fg = "NONE" })
			hl(0, "CmpItemAbbrDeprecated", { fg = "#7E8294", bg = "NONE", strikethrough = true })
			hl(0, "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
			hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
			hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })
			hl(0, "CmpItemKindField", { fg = "#EED8DA", bg = "#B5585F" })
			hl(0, "CmpItemKindProperty", { fg = "#EED8DA", bg = "#B5585F" })
			hl(0, "CmpItemKindEvent", { fg = "#EED8DA", bg = "#B5585F" })
			hl(0, "CmpItemKindText", { fg = "#C3E88D", bg = "#9FBD73" })
			hl(0, "CmpItemKindEnum", { fg = "#C3E88D", bg = "#9FBD73" })
			hl(0, "CmpItemKindKeyword", { fg = "#C3E88D", bg = "#9FBD73" })
			hl(0, "CmpItemKindConstant", { fg = "#FFE082", bg = "#D4BB6C" })
			hl(0, "CmpItemKindConstructor", { fg = "#FFE082", bg = "#D4BB6C" })
			hl(0, "CmpItemKindReference", { fg = "#FFE082", bg = "#D4BB6C" })
			hl(0, "CmpItemKindFunction", { fg = "#EADFF0", bg = "#A377BF" })
			hl(0, "CmpItemKindStruct", { fg = "#EADFF0", bg = "#A377BF" })
			hl(0, "CmpItemKindClass", { fg = "#EADFF0", bg = "#A377BF" })
			hl(0, "CmpItemKindModule", { fg = "#EADFF0", bg = "#A377BF" })
			hl(0, "CmpItemKindOperator", { fg = "#EADFF0", bg = "#A377BF" })
			hl(0, "CmpItemKindVariable", { fg = "#C5CDD9", bg = "#7E8294" })
			hl(0, "CmpItemKindFile", { fg = "#C5CDD9", bg = "#7E8294" })
			hl(0, "CmpItemKindUnit", { fg = "#F5EBD9", bg = "#D4A959" })
			hl(0, "CmpItemKindSnippet", { fg = "#F5EBD9", bg = "#D4A959" })
			hl(0, "CmpItemKindFolder", { fg = "#F5EBD9", bg = "#D4A959" })
			hl(0, "CmpItemKindMethod", { fg = "#DDE5F5", bg = "#6C8ED4" })
			hl(0, "CmpItemKindValue", { fg = "#DDE5F5", bg = "#6C8ED4" })
			hl(0, "CmpItemKindEnumMember", { fg = "#DDE5F5", bg = "#6C8ED4" })
			hl(0, "CmpItemKindInterface", { fg = "#D8EEEB", bg = "#58B5A8" })
			hl(0, "CmpItemKindColor", { fg = "#D8EEEB", bg = "#58B5A8" })
			hl(0, "CmpItemKindTypeParameter", { fg = "#D8EEEB", bg = "#58B5A8" })
		end,
	},
}
