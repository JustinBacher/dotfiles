local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("config.lazyfile").setup()

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	defaults = { lazy = true, version = "*" },
	checker = { enabled = true },
	performance = {
		rtp = {
			disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", },
		},
	},
 { "jsongerber/thanks.nvim", config = true }
})
