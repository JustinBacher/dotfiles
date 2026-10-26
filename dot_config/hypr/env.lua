-- Environment inherited by applications launched from Hyprland.
local apps = require("variables")

local groups = {
	-- Session
	{
		XDG_CURRENT_DESKTOP = "Hyprland",
		XDG_SESSION_TYPE = "wayland",
		XDG_SESSION_DESKTOP = "Hyprland",
		XDG_CONFIG_HOME = apps.config_home,
		XDG_CACHE_HOME = apps.cache_home,
	},
	-- Wayland applications and toolkits
	{
		QT_QPA_PLATFORM = "wayland",
		MOZ_ENABLE_WAYLAND = "1",
		ELECTRON_OZONE_PLATFORM_HINT = "wayland",
		QT_QPA_PLATFORMTHEME = "qt6ct",
		QT_WAYLAND_DISABLE_WINDOWDECORATION = "1",
		QT_AUTO_SCREEN_SCALE_FACTOR = "1",
	},
	-- Cursor themes
	{
		XCURSOR_THEME = "GoogleDot-Matugen",
		XCURSOR_SIZE = "20",
		HYPRCURSOR_THEME = "GoogleDot-Matugen",
		HYPRCURSOR_SIZE = "20",
	},
	-- Application preferences
	{
		GCM_CREDENTIAL_STORE = "gpg",
		LANG = "en_US.UTF-8",
		LC_ALL = "en_US.UTF-8",
		FZF_DEFAULT_OPTS = "--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'",
	},
	-- NVIDIA and Vulkan
	{
		-- Stable, colon-free link to the RTX 2070 SUPER DRM device.
		AQ_DRM_DEVICES = apps.config_home .. "/hypr/render-gpu",
		VK_DEVICE_SELECT_PCI_BUS_ID = "00000000:04:00.0",
		GBM_BACKEND = "nvidia-drm",
		LIBVA_DRIVER_NAME = "nvidia",
		__GLX_VENDOR_LIBRARY_NAME = "nvidia",
		__GL_VRR_ALLOWED = "0",
		NVD_BACKEND = "direct",
	},
}

-- Values are independent; only group ordering matters for readability.
for _, group in ipairs(groups) do
	for name, value in pairs(group) do
		hl.env(name, value)
	end
end
