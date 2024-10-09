require("config.options")

require("config.lazy")

require("config.theme")
require("config.autocmds")

local remaps = require("config.remaps")
for _, remap in ipairs(remaps) do
	local bind = table.remove(remap, 1)
	local result = table.remove(remap, 1)
	local mode = remap.mode or "n"
	remap.mode = nil
	remap.noremap = remap.noremap or true

	vim.keymap.set(mode, bind, result, remap)
end
