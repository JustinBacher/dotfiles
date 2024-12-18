---@diagnostic disable-next-line: unused-local
local function on_attach(client, bufnr)
	-- X.set_default_on_buffer(client, bufnr)
	local ok, lsp_signature = pcall(require, "lsp_signature")
	if ok then lsp_signature.on_attach({ floating_window = false, timer_interval = 500 }) end
end

local default_lsp_config = {
	on_attach = on_attach,
	flags = { debounce_text_changes = 200, allow_incremental_sync = true },
}

local function make_config(opts) return vim.tbl_deep_extend("force", default_lsp_config, opts) end

return {
	dockerls = default_lsp_config,
	html = default_lsp_config,
	jsonls = default_lsp_config,
	lua_ls = make_config({
		filetypes = { "lua", "lua.tmpl" },
		["on_attach"] = function(client, bufnr)
			on_attach(client, bufnr)
			client.server_capabilities.document_formatting = false
			client.server_capabilities.document_range_formatting = false
		end,
		settings = {
			Lua = {
				hint = { enable = true },
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					checkThirdParty = false,
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					},
				},
			},
		},
	}),
	ruff = default_lsp_config,
	tailwindcss = default_lsp_config,
	terraformls = default_lsp_config,
	tflint = default_lsp_config,
	ts_ls = default_lsp_config,
	yamlls = default_lsp_config,
	taplo = default_lsp_config,
}
