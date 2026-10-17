-- Keybindings and metadata used by the keybind hint menu.
local apps = require("variables")
-- Rebuilt on each reload; actions remain callable by the hint menu.
local bindings = {}
local mod = apps.main_mod
local function bind(keys, action, description, options)
	options = options or {}
	options.description = description
	bindings[#bindings + 1] = {
		keys = keys,
		action = action,
		description = description,
		options = options,
	}
	hl.bind(keys, action, options)
end

local function bind_workspaces(modifiers, action, description)
	for workspace = 1, 10 do
		local id = tostring(workspace)
		bind(modifiers .. " + " .. workspace % 10, action(id), description .. " " .. id)
	end
end

local function focus_horizontal(direction)
	return function()
		local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
		local window = hl.get_active_window()
		if workspace and workspace.tiled_layout == "scrolling" and window and not window.floating then
			hl.dispatch(hl.dsp.layout("focus " .. (direction == "left" and "l" or "r")))
		else
			hl.dispatch(hl.dsp.focus({ direction = direction }))
		end
	end
end

local function swap_window(direction)
	return function()
		local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
		local window = hl.get_active_window()
		if workspace and workspace.tiled_layout == "scrolling" and window and not window.floating
			and (direction == "left" or direction == "right") then
			hl.dispatch(hl.dsp.layout("swapcol " .. (direction == "left" and "l" or "r")))
		else
			hl.dispatch(hl.dsp.window.swap({ direction = direction }))
		end
	end
end

local function toggle_pin()
	local window = hl.get_active_window()
	if not window then
		return
	end
	local was_pinned = window.pinned
	if not window.floating and not was_pinned then
		hl.dispatch(hl.dsp.window.float({ action = "set", window = window }))
	end
	hl.dispatch(hl.dsp.window.pin({ action = "toggle", window = window }))
	if was_pinned then
		hl.dispatch(hl.dsp.window.float({ action = "unset", window = window }))
	end
end

bind(mod .. " + Q", hl.dsp.exec_cmd(apps.script("dontkillsteam.sh")), "killactive, kill the window on focus")
bind("ALT + F4", hl.dsp.exec_cmd(apps.script("dontkillsteam.sh")), "killactive, kill the window on focus")
bind(mod .. " + Delete", hl.dsp.exit(), "kill hyperland session")
bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }), "toggle the window on focus to float")
bind(mod .. " + G", hl.dsp.exec_cmd("steam steam://open/games"), "open Steam library")
bind(mod .. " + Return", hl.dsp.window.fullscreen(), "toggle the window on focus to fullscreen")
bind(
	mod .. " + SHIFT + Return",
	hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle", layout_aware = true }),
	"expand or restore focused window"
)
bind(mod .. " + CTRL + F", toggle_pin, "toggle pin on focused window")
bind(mod .. " + BackSpace", hl.dsp.exec_cmd("noctalia msg panel-toggle session"), "open session menu")
bind(mod .. " + D", hl.dsp.exec_cmd("vesktop"), "Open Vesktop")
bind(
	mod .. " + SHIFT + T",
	hl.dsp.exec_cmd("env GDK_WAYLAND_DISABLE=ext_background_effect_manager_v1 " .. apps.terminal .. " --gtk-single-instance=false"),
	"open terminal"
)
bind(mod .. " + E", hl.dsp.exec_cmd(apps.file_manager), "open file manager")
bind(mod .. " + C", hl.dsp.exec_cmd(apps.editor), "open editor")
bind(mod .. " + B", hl.dsp.exec_cmd(apps.browser), "open browser")
bind(mod .. " + A", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"), "open Noctalia control center")
bind(
	"CTRL + SHIFT + Escape",
	hl.dsp.exec_cmd(apps.script("sysmonlaunch.sh") .. " " .. apps.shell_quote(apps.terminal)),
	"open htop/btop if installed or default to top (system monitor)"
)
bind(
	mod .. " + SUPER_L",
	hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"),
	"launch desktop applications",
	{ release = true }
)
bind(mod .. " + ALT + Tab", hl.dsp.focus({ workspace = "e+1" }), "workspace e+1")
bind(mod .. " + SHIFT + ALT + Tab", hl.dsp.focus({ workspace = "e-1" }), "workspace e-1")
bind(mod .. " + R", hl.dsp.exec_cmd(apps.file_manager), "browse files")
bind("F10", hl.dsp.exec_cmd(apps.script("volumecontrol.sh") .. " -o m"), "toggle audio mute", { locked = true })
bind(
	"F11",
	hl.dsp.exec_cmd(apps.script("volumecontrol.sh") .. " -o d"),
	"decrease volume",
	{ locked = true, repeating = true }
)
bind(
	"F12",
	hl.dsp.exec_cmd(apps.script("volumecontrol.sh") .. " -o i"),
	"increase volume",
	{ locked = true, repeating = true }
)
bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd(apps.script("volumecontrol.sh") .. " -o m"),
	"toggle audio mute",
	{ locked = true }
)
bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd(apps.script("volumecontrol.sh") .. " -i m"),
	"toggle microphone mute",
	{ locked = true }
)
bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(apps.script("volumecontrol.sh") .. " -o d"),
	"decrease volume",
	{ locked = true, repeating = true }
)
bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(apps.script("volumecontrol.sh") .. " -o i"),
	"increase volume",
	{ locked = true, repeating = true }
)
bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), "exec playerctl play-pause", { locked = true })
bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), "exec playerctl play-pause", { locked = true })
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), "exec playerctl next", { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), "exec playerctl previous", { locked = true })
bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(apps.script("brightnesscontrol.sh") .. " i"),
	"increase brightness",
	{ locked = true, repeating = true }
)
bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(apps.script("brightnesscontrol.sh") .. " d"),
	"decrease brightness",
	{ locked = true, repeating = true }
)
bind(
	mod .. " + SHIFT + S",
	hl.dsp.exec_cmd(apps.script("screenshot-selection.sh") .. " area"),
	"capture a screen region to clipboard"
)
bind(
	mod .. " + CTRL + S",
	hl.dsp.exec_cmd(apps.script("screenshot-selection.sh") .. " window"),
	"select a window to capture to clipboard"
)
bind(
	mod .. " + S",
	hl.dsp.exec_cmd("noctalia msg screenshot-annotate"),
	"freeze screen and annotate"
)
bind(mod .. " + P", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"), "capture focused monitor")
bind("Print", hl.dsp.exec_cmd(apps.script("screenshot-all.sh")), "capture all monitors")
bind(mod .. " + ALT + G", hl.dsp.exec_cmd(apps.script("gamemode.sh")), "disable hypr effects for gamemode")
bind(mod .. " + ALT + up", hl.dsp.exec_cmd(apps.script("wbarconfgen.sh") .. " n"), "next waybar mode")
bind(mod .. " + ALT + down", hl.dsp.exec_cmd(apps.script("wbarconfgen.sh") .. " p"), "previous waybar mode")
bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd(apps.script("wallbashtoggle.sh")), "toggle wallbash on/off")
bind(
	mod .. " + SHIFT + A",
	hl.dsp.exec_cmd("noctalia msg settings-open"),
	"open Noctalia settings"
)
bind(
	mod .. " + SHIFT + W",
	hl.dsp.exec_cmd("noctalia msg wallpaper-random"),
	"next wallpaper"
)
bind(
	mod .. " + V",
	hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"),
	"open clipboard history"
)
bind(mod .. " + ALT + SHIFT + K", hl.dsp.exec_cmd(apps.script("keyboardswitch.sh")), "change keyboard layout")
bind(mod .. " + left", focus_horizontal("left"), "movefocus l")
bind(mod .. " + h", focus_horizontal("left"), "vim motion for left")
bind(mod .. " + right", focus_horizontal("right"), "movefocus r")
bind(mod .. " + l", focus_horizontal("right"), "vim motion for right")
bind(mod .. " + up", hl.dsp.focus({ direction = "up" }), "movefocus u")
bind(mod .. " + k", hl.dsp.focus({ direction = "up" }), "vim motion for up")
bind(mod .. " + down", hl.dsp.focus({ direction = "down" }), "movefocus d")
bind(mod .. " + j", hl.dsp.focus({ direction = "down" }), "vim motion for down")
bind(mod .. " + ALT + h", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), "shrink window width", { repeating = true })
bind(mod .. " + ALT + j", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), "grow window height", { repeating = true })
bind(mod .. " + ALT + k", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), "shrink window height", { repeating = true })
bind(mod .. " + ALT + l", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), "grow window width", { repeating = true })
bind(mod .. " + CTRL + h", swap_window("left"), "swap window left")
bind(mod .. " + CTRL + j", swap_window("down"), "swap window down")
bind(mod .. " + CTRL + k", swap_window("up"), "swap window up")
bind(mod .. " + CTRL + l", swap_window("right"), "swap window right")
bind(mod .. " + SHIFT + J", hl.dsp.layout("togglesplit"), "toggle horizontal/vertical window split")
bind("ALT + Tab", hl.dsp.focus({ direction = "down" }), "movefocus d")
bind_workspaces(mod, function(workspace)
	return hl.dsp.focus({ workspace = workspace })
end, "workspace")
bind(mod .. " + CTRL + right", hl.dsp.focus({ workspace = "r+1" }), "workspace r+1")
bind(mod .. " + CTRL + left", hl.dsp.focus({ workspace = "r-1" }), "workspace r-1")
bind(mod .. " + CTRL + down", hl.dsp.focus({ workspace = "empty" }), "workspace empty")
bind_workspaces(mod .. " + SHIFT", function(workspace)
	return hl.dsp.window.move({ workspace = workspace })
end, "movetoworkspace")
bind(mod .. " + CTRL + ALT + right", hl.dsp.window.move({ workspace = "r+1" }), "movetoworkspace r+1")
bind(mod .. " + CTRL + ALT + left", hl.dsp.window.move({ workspace = "r-1" }), "movetoworkspace r-1")
bind(mod .. " + SHIFT + CTRL + left", hl.dsp.window.move({ direction = "left" }), "movewindow l")
bind(mod .. " + SHIFT + CTRL + right", hl.dsp.window.move({ direction = "right" }), "movewindow r")
bind(mod .. " + SHIFT + CTRL + up", hl.dsp.window.move({ direction = "up" }), "movewindow u")
bind(mod .. " + SHIFT + CTRL + down", hl.dsp.window.move({ direction = "down" }), "movewindow d")
bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "workspace e+1")
bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), "workspace e-1")
bind(mod .. " + mouse:272", hl.dsp.window.drag(), "movewindow")
bind(mod .. " + ALT + mouse:272", hl.dsp.window.resize(), "resizewindow")
bind(mod .. " + Z", hl.dsp.window.drag(), "movewindow")
bind(mod .. " + X", hl.dsp.window.resize(), "resizewindow")
bind(
	mod .. " + ALT + grave",
	hl.dsp.window.move({ workspace = "special:", follow = false }),
	"Send window to scratchpad"
)
bind(mod .. " + grave", hl.dsp.workspace.toggle_special(), "Toggle scratchpad")
bind_workspaces(mod .. " + ALT", function(workspace)
	return hl.dsp.window.move({ workspace = workspace, follow = false })
end, "movetoworkspacesilent")
bind(mod .. " + SHIFT + G", hl.dsp.group.toggle(), "Toggle the current window into/out of a group")
bind(mod .. " + TAB", hl.dsp.group.next(), "Cycle forward through windows in the group")
bind(mod .. " + SHIFT + TAB", hl.dsp.group.prev(), "Cycle backward through windows in the group")
bind(
	mod .. " + SHIFT + Left",
	hl.dsp.window.move({ into_group = "left" }),
	"Move the active window into a group (to the left; change 'l' to desired direction)"
)
bind(mod .. " + U", hl.dsp.window.move({ out_of_group = true }), "Remove the active window from its group")
bind(
	mod .. " + CTRL + SHIFT + L",
	hl.dsp.group.lock_active({ action = "toggle" }),
	"Optionally, lock the current group to prevent new windows from joining (toggle lock)"
)
bind(mod .. " + SHIFT + n", hl.dsp.exec_cmd("swaync-client -t -sw"), "exec swaync-client -t -sw")

return bindings
