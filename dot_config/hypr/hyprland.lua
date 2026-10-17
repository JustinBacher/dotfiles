-- Hyprland 0.56 Lua configuration. Legacy .conf files are fallback copies.
local apps = require("variables")

hl.on("hyprland.start", function()
	for _, command in ipairs({
		apps.script("resetxdgportal.sh"),
		"dbus-update-activation-environment --systemd --all",
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
		"systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
		apps.script("polkitkdeauth.sh"),
		"nm-applet --indicator",
		"noctalia",
		"keeper ssh-agent start",
	}) do
		hl.exec_cmd(command)
	end
end)

hl.config({
	input = {
		kb_layout = "us",
		follow_mouse = 1,
		sensitivity = 0,
		force_no_accel = true,
		touchpad = { natural_scroll = true },
	},
	dwindle = { preserve_split = true },
	misc = {
		vrr = 1,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
	},
})
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

-- Keep the original order so later settings and rules retain their precedence.
require("env")
require("animations")
-- Expose one bridge for the external keybind hint menu.
require("keybindings")
require("windowrules")
require("theme")
require("monitors")
require("nvidia")
require("plugins")

-- For Noctalia Color templates
require("noctalia").apply_theme()
