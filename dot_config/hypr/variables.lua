-- Shared application choices and shell-safe script paths.
local home = assert(os.getenv("HOME"), "HOME is required")
local config_home = home .. "/.config"

local M = {
	home = home,
	config_home = config_home,
	cache_home = home .. "/.cache",
	terminal = "ghostty",
	editor = "nvim",
	file_manager = "dolphin --style kvantum --stylesheet " .. config_home .. "/dolphin/noctalia-glass.qss",
	browser = "zen-browser",
	main_mod = "SUPER",
}

function M.shell_quote(value)
	return "'" .. value:gsub("'", "'\"'\"'") .. "'"
end

function M.script(name)
	return M.shell_quote(config_home .. "/hypr/scripts/" .. name)
end

return M
