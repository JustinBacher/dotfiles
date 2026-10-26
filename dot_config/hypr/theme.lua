-- Appearance and toolkit settings.
hl.config({
	general = {
		gaps_in = 12,
		gaps_out = { top = 15, right = 30, bottom = 30, left = 30 },
		border_size = 0,
		allow_tearing = false,
		layout = "scrolling",
		resize_on_border = true,
		col = { active_border = { colors = { "rgb(EBBCBA)", "rgb(EBBCBA)" }, angle = 45 } },
	},
	scrolling = {
		column_width = 0.75,
		focus_fit_method = 1,
	},
	group = {
		groupbar = {
			enabled = true,
			font_family = "Maple Mono",
			font_size = 12,
			gradients = false,
			height = 15,
			col = {
				active = "0x88000000",
				inactive = "0x00000000",
				locked_active = "0x00000088",
				locked_inactive = "0x00000088",
			},
		},
	},
	decoration = {
		rounding = 22,
		dim_special = 0.3,
		dim_inactive = true,
		dim_strength = 0.2,
		blur = {
			enabled = true,
			-- Hyprglass also uses these values for its redraw damage margin.
			size = 6,
			passes = 3,
			noise = 0.18,
			-- ignore_opacity = false,
			vibrancy = 0.4842,
			vibrancy_darkness = 0.9612,
			new_optimizations = true,
			brightness = 0.35,
		},
		shadow = {
			enabled = true,
			offset = { 0, 0 },
			color = "rgba(00000055)",
			range = 12,
			render_power = 2,
			scale = 0.98,
		},
	},
})

-- Wallust owns colors.lua. An absent initial palette uses the colors above;
-- errors inside an existing palette must still be reported by Hyprland.
local palette = io.open(debug.getinfo(1, "S").source:sub(2):match("(.*/)") .. "colors.lua", "r")
if palette then
	palette:close()
	require("colors")
end

local function apply_toolkit_theme()
	for _, command in ipairs({
		"python3 ~/.config/hypr/scripts/recolor-cursor.py --apply-only",
		"gsettings set org.gnome.desktop.interface font-name 'Maple Mono 10'",
		"gsettings set org.gnome.desktop.interface document-font-name 'Maple Mono 10'",
		"gsettings set org.gnome.desktop.interface monospace-font-name 'Maple Mono NF 9'",
		"gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'",
		"gsettings set org.gnome.desktop.interface font-hinting 'full'",
		"gsettings set org.gnome.desktop.interface icon-theme 'oomox-Tokyonight-Dark'",
		"gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'",
		"gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'",
	}) do
		hl.exec_cmd(command)
	end
end
hl.on("hyprland.start", apply_toolkit_theme)
hl.on("config.reloaded", function()
	-- Initial configuration and offline verification have no live monitors.
	-- Startup applies the theme once the compositor is ready.
	if #hl.get_monitors() > 0 then
		apply_toolkit_theme()
	end
end)
