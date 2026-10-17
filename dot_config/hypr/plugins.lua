local function native_config(name, entry)
	local plugin = hl.plugin[name]

	plugin.config(entry.options)

	for method, calls in pairs(entry.callables or {}) do
		for _, args in ipairs(calls) do
			plugin[method](table.unpack(args))
		end
	end
end

local function hyprland_config(name, entry)
	hl.config({ plugin = { [name] = entry.options } })
end

local plugins = {
	hyprglass = {
		apply = native_config,
		options = {
			enabled = true,
			default_theme = "dark",
			default_preset = "frosted",

			-- tint_color = 0x8899aa22,

			brightness = 0.9,
			dark = { brightness = 0.82 },
			light = { adaptive_boost = 0.5 },

			layers = { enabled = true },
		},
		callables = {
			-- Match the surfaces covered by windowrules.lua's blur rules.
			-- Hyprglass uses mask_threshold in place of ignore_alpha.
			layer = {
				{
					"caelestia-drawers",
					{ preset = "edge_glass", mask_mode = "alpha", mask_threshold = 0.5, mask_feather = 0.1 },
				},
				{ "noctalia-bar-default", { preset = "edge_glass", mask_threshold = 0.5 } },
				{ "noctalia-bar-top", { preset = "edge_glass", mask_threshold = 0.3 } },
				{ "noctalia-bar-bottom", { preset = "edge_glass", mask_threshold = 0.3 } },
				{ "noctalia-notification", { preset = "edge_glass", mask_threshold = 0.5 } },
				{ "noctalia-dock", { preset = "edge_glass", mask_threshold = 0.5 } },
				{ "noctalia-panel", { preset = "edge_glass", mask_threshold = 0.5 } },
				{ "noctalia-attached-panel", { preset = "edge_glass", mask_threshold = 0.5 } },
				{ "noctalia-osd", { preset = "edge_glass", mask_threshold = 0.5 } },
				{ "noctalia-launcher", { preset = "frosted", mask_threshold = 0.5 } },
				{ "noctalia-window-switcher", { preset = "edge_glass", mask_threshold = 0.5 } },
				{ "rofi", { preset = "clear", mask_threshold = 0.0 } },
				{ "anyrun", { preset = "clear", mask_threshold = 0.0 } },
				{ "gbar", { preset = "clear" } },
				{ "logout_dialog", { preset = "clear" } },
				{ "swaync-control-center", { preset = "clear_xray", mask_threshold = 0.7 } },
				{ "swaync-notification-window", { preset = "clear", mask_threshold = 0.7 } },
			},
			preset = {
				{
					"clear",
					{
						glass_opacity = 0.8,
						blur_strength = 0.3,
						tint_color = 0x00000000,
						dark = {
							brightness = 1.0,
							contrast = 1.0,
							saturation = 1.0,
							adaptive_dim = 0.0,
						},
					},
				},
				{ "clear_xray", { inherits = "clear", xray = true } },
				{
					"edge_glass",
					{
						inherits = "clear",
						glass_opacity = 1.0,
						blur_strength = 0.4,
						refraction_strength = 2.4,
						refraction_spread = 0.0,
						lens_distortion = 0.0,
						chromatic_aberration = 0.8,
						fresnel_strength = 1.1,
						specular_strength = 1.0,
						-- Scale the rim for full-sized windows, with a crisp 2px bevel.
					},
				},
				{
					"transparent_blur",
					{
						inherits = "edge_glass",
						blur_strength = 1.5,
					},
				},
				{
					"frosted",
					{
						inherits = "clear",
						glass_opacity = 1.0,
						-- tint_color = 0x20202099,
						-- Approximate a clearer center with lighter blur and rim-only distortion.
						blur_strength = 0.5,
						refraction_strength = 1.8,
						refraction_spread = 0.2,
						lens_distortion = 0.0,
						noise_strength = 0.0,
					},
				},
				{
					"noctalia_glass",
					{
						inherits = "clear",
						glass_opacity = 0.95,
						-- Thin bars need a visible rim rather than heavy frosting.
						blur_strength = 0.65,
						refraction_strength = 1.6,
						chromatic_aberration = 0.6,
						fresnel_strength = 0.9,
						edge_thickness = 0.15,
						bevel_strength = 0.65,
						bevel_size = 1.0,
						noise_strength = 0.0,
					},
				},
				{
					"noctalia_bar",
					{
						inherits = "noctalia_glass",
						-- A wider relative rim remains visible on the 34px bar.
						edge_thickness = 0.15,
					},
				},
			},
		},
	},

	dynamic_cursors = {
		apply = hyprland_config,
		options = {
			enabled = true,
			mode = "stretch",
			stretch = {

				-- controls how much the cursor is stretched
				-- this value controls at which speed (px/s) the full stretch is reached
				-- the full stretch being twice the original length
				limit = 3000,

				-- relationship between speed and stretch amount, supports these values:
				-- linear             - a linear function is used
				-- quadratic          - a quadratic function is used
				-- negative_quadratic - negative version of the quadratic one, feels more aggressive
				-- see `activation` in `src/mode/utils.cpp` for how exactly the calculation is done
				activation = "quadratic",

				-- time window (ms) over which the speed is calculated
				-- higher values will make slow motions smoother but more delayed
				window = 100,
			},
			shake = {
				enabled = false,
			},
		},
	},
	hyprcursor = {

		-- use nearest-neighbour (pixelated) scaling when magnifying beyond texture size
		-- this will also have effect without hyprcursor support being enabled
		-- 0 - never use pixelated scaling
		-- 1 - use pixelated when no highres image
		-- 2 - always use pixelated scaling
		nearest = 1,

		-- enable dedicated hyprcursor support
		enabled = true,

		-- resolution in pixels to load the magnified shapes at
		-- be warned that loading a very high-resolution image will take a long time and might impact memory consumption
		-- -1 means we use [normal cursor size] * [shake:base option]
		resolution = -1,

		-- shape to use when clientside cursors are being magnified
		-- see the shape-name property of shape rules for possible names
		-- specifying clientside will use the actual shape, but will be pixelated
		fallback = "clientside",
	},
}

for name, entry in pairs(plugins) do
	if hl.plugin[name] then
		entry.apply(name, entry)
	end
end

hl.on("hyprland.start", function()
	-- Keep the startup delay in the child process so a config reload cannot
	-- cancel plugin loading. An absent hyprpm leaves plugin settings inactive.
	hl.exec_cmd("sleep 2 && command -v hyprpm >/dev/null 2>&1 && hyprpm reload")
end)
