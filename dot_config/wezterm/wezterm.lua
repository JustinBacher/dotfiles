local wezterm = require("wezterm")
local config = {} or wezterm.config_builder()
local act = wezterm.action
local is_linux = wezterm.target_triple:find("linux") ~= nil
local is_darwin = wezterm.target_triple:find("darwin")
local is_windows = wezterm.target_triple:find("windows")

-- ██████╗ ██╗     ██╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
-- ██╔══██╗██║     ██║   ██║██╔════╝ ██║████╗  ██║██╔════╝
-- ██████╔╝██║     ██║   ██║██║  ███╗██║██╔██╗ ██║███████╗
-- ██╔═══╝ ██║     ██║   ██║██║   ██║██║██║╚██╗██║╚════██║
-- ██║     ███████╗╚██████╔╝╚██████╔╝██║██║ ╚████║███████║
-- ╚═╝     ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL",
		resize = "CTRL|SHIFT",
	},
})

--  ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
-- ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
-- ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
-- ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
-- ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
--  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝

config.window_close_confirmation = "NeverPrompt"
config.warn_about_missing_glyphs = false

-- Tmux like sessions
config.unix_domains = { { name = "unix" } }
config.default_gui_startup_args = { "connect", "unix" }

-- Input
-- config.enable_kitty_keyboard = true
-- config.use_ime = true

-- Only visual bell
config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_duration_ms = 20,
	fade_out_duration_ms = 200,
	fade_in_function = "Linear",
	fade_out_function = "EaseOut",
}

-- Wayland fix
if os.getenv("XDG_SESSION_TYPE") == "wayland" then
	config.enable_wayland = true
	config.front_end = "OpenGL"
end

-- ███████╗ ██████╗ ███╗   ██╗████████╗
-- ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝
-- █████╗  ██║   ██║██╔██╗ ██║   ██║
-- ██╔══╝  ██║   ██║██║╚██╗██║   ██║
-- ██║     ╚██████╔╝██║ ╚████║   ██║
-- ╚═╝      ╚═════╝ ╚═╝  ╚═══╝   ╚═╝

config.font = wezterm.font_with_fallback({
	{ family = "Comic Code Ligatures", weight = "Regular", stretch = "Normal", style = "Normal" },
	{ family = "Comic Code", weight = "Regular", stretch = "Normal", style = "Normal" },
	-- { family = "VictorMono Nerd Font", weight = "Medium", stretch = "Normal" },
	{ family = "Symbols Nerd Font", weight = "Regular" },
})

if is_darwin then
	config.font_size = 15
else
	config.font_size = 12
end

--  ██████╗██╗   ██╗██████╗ ███████╗ ██████╗ ██████╗
-- ██╔════╝██║   ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗
-- ██║     ██║   ██║██████╔╝███████╗██║   ██║██████╔╝
-- ██║     ██║   ██║██╔══██╗╚════██║██║   ██║██╔══██╗
-- ╚██████╗╚██████╔╝██║  ██║███████║╚██████╔╝██║  ██║
--  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝

config.default_cursor_style = "BlinkingBar"
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "EaseOut"

-- ██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ███████╗
-- ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██╔════╝
-- █████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║███████╗
-- ██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║╚════██║
-- ██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝███████║
-- ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝

-- local move_around = function(window, pane, direction_wez, direction_nvim)
-- 	if pane:get_title():lower() == "nvim" then
-- 		window:perform_action(wezterm.action({ SendString = "\x17" .. direction_nvim }), pane)
-- 	else
-- 		window:perform_action(wezterm.action({ ActivatePaneDirection = direction_wez }), pane)
-- 	end
-- end

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	-- Splitting panes
	{
		key = "h",
		mods = "ALT",
		action = act.Multiple({ act.SplitPane({ direction = "Left", size = { Percent = 50 } }) }),
	},
	{
		key = "j",
		mods = "ALT",
		action = act.Multiple({ act.SplitPane({ direction = "Down", size = { Percent = 50 } }) }),
	},
	{
		key = "k",
		mods = "ALT",
		action = act.Multiple({ act.SplitPane({ direction = "Down", size = { Percent = 50 } }) }),
	},
	{
		key = "l",
		mods = "ALT",
		action = act.Multiple({ act.SplitPane({ direction = "Right", size = { Percent = 50 } }) }),
	},

	-- Focusing Panes
	{ key = "h", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL", action = act.ActivatePaneDirection("Right") },

	{ key = "Escape", mods = "ALT", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
}

-- leader + number to activate that tab
for i = 0, 9 do
	table.insert(config.keys, { key = tostring(i), mods = "ALT", action = act.ActivateTab(i) })
end

config.key_tables = {
	resize_pane = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 3 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 3 }) },
		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 3 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 3 }) },
		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 3 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 3 }) },
		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 3 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 3 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},
}

wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x1f30a) --- @diagnostic disable-line undefined-global
		SOLID_LEFT_ARROW = utf8.char(0xe0b2) --- @diagnostic disable-line undefined-global
	end

	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
	end -- arrow color based on if tab is first pane

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#b7bdf8" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)

-- ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗
-- ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║
-- ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║
-- ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║
-- ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝
-- ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝

-- This is because we are using a tiling window manager
if is_darwin then
	config.window_decorations = "RESIZE"
elseif is_windows then
	config.window_decorations = "NONE"
end

-- tab bar
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true

-- ██████╗ ██████╗ ██╗      ██████╗ ██████╗ ███████╗
-- ██╔════╝██╔═══██╗██║     ██╔═══██╗██╔══██╗██╔════╝
-- ██║     ██║   ██║██║     ██║   ██║██████╔╝███████╗
-- ██║     ██║   ██║██║     ██║   ██║██╔══██╗╚════██║
-- ╚██████╗╚██████╔╝███████╗╚██████╔╝██║  ██║███████║
--  ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝

config.color_scheme = "Tokyo Night Moon"

if is_darwin then
	config.window_background_opacity = 0.7
	config.macos_window_background_blur = 20
elseif is_linux then
	config.window_background_opacity = 0.0
	config.window_background_opacity = 0.6
end

config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.3,
}

-- Ensure the wezterm TERM definitions are installed for wezterm TERM to work
-- otherwise set to xterm-256color. Follow the line below to install the definitions
-- https://wezfurlong.org/wezterm/config/lua/config/term.html?h=term#term-xterm-256color
config.term = "wezterm"

return config
