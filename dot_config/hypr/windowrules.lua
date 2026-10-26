-- Appearance and layer rules register in declaration order.
local window_rules = {
    { name = "appearance-zen-glass", match = { class = "^(zen)$" }, tag = "+hyprglass_preset_edge_glass" },
    { name = "appearance-ghostty-glass", match = { class = "^(com\\.mitchellh\\.ghostty)$" }, tag = "+hyprglass_preset_transparent_blur" },
    { name = "appearance-firefox-opacity", match = { class = "^(firefox)$" }, opacity = "0.90 0.90" },
    { name = "appearance-firefox-capitalized-opacity", match = { class = "^(Firefox)$" }, opacity = "0.90 0.90" },
    { name = "appearance-steam-capitalized-opacity", match = { class = "^(Steam)$" }, opacity = "1.0 override 1.0 override" },
    { name = "appearance-steam-opacity", match = { class = "^(steam)$" }, opacity = "1.0 override 1.0 override" },
    { name = "appearance-steamwebhelper-opacity", match = { class = "^(steamwebhelper)$" }, opacity = "1.0 override 1.0 override" },
    {
        name = "appearance-steam-glass",
        match = { class = "^(steam|Steam|steamwebhelper)$", title = "^(Steam)$" },
        tag = "+hyprglass_preset_transparent_blur",
    },
    { name = "appearance-spotify-glass", match = { class = "^(Spotify)$" }, opacity = "1.00 1.00", tag = "+hyprglass_preset_transparent_blur" },
    { name = "appearance-code-url-handler-opacity", match = { class = "^(code-url-handler)$" }, opacity = "0.80 0.80" },
    { name = "appearance-kitty-opacity", match = { class = "^(kitty)$" }, opacity = "1.00 0.80" },
    { name = "appearance-wezterm-opacity", match = { class = "^(wezterm)$" }, opacity = "0.20 0.30" },
    { name = "appearance-cursor-opacity", match = { class = ".*(Cursor:)$" }, opacity = "0.20 0.30" },
    {
        name = "appearance-dolphin-glass",
        match = { class = "^(org.kde.dolphin)$" },
        -- The app stylesheet controls regional opacity; whole-window opacity would compound it.
        tag = "+hyprglass_preset_transparent_blur",
    },
    { name = "appearance-ark-appearance", match = { class = "^(org.kde.ark)$" }, float = true, opacity = "0.80 0.80" },
    {
        name = "appearance-nwg-look-appearance",
        match = { class = "^(nwg-look)$" },
        float = true,
        opacity = "0.80 0.80",
    },
    { name = "appearance-qt5ct-appearance", match = { class = "^(qt5ct)$" }, float = true, opacity = "0.80 0.80" },
    { name = "appearance-qt6ct-appearance", match = { class = "^(qt6ct)$" }, float = true, opacity = "0.80 0.80" },
    {
        name = "appearance-kvantummanager-appearance",
        match = { class = "^(kvantummanager)$" },
        float = true,
        opacity = "0.80 0.80",
    },
    {
        name = "appearance-clapper-appearance",
        match = { class = "^(com.github.rafostar.Clapper)$" },
        float = true,
        opacity = "0.90 0.90",
    },
    {
        name = "appearance-flatseal-opacity",
        match = { class = "^(com.github.tchx84.Flatseal)$" },
        opacity = "0.80 0.80",
    },
    { name = "appearance-cartridges-opacity", match = { class = "^(hu.kramo.Cartridges)$" }, opacity = "0.80 0.80" },
    {
        name = "appearance-obs-opacity",
        match = { class = "^(com.obsproject.Studio)$" },
        -- Whole-window transparency also fades the preview and every dialog.
        opacity = "1.0 override 1.0 override",
        tag = "+hyprglass_preset_clear",
    },
    { name = "appearance-gnome-boxes-opacity", match = { class = "^(gnome-boxes)$" }, opacity = "0.80 0.80" },
    { name = "appearance-discord-opacity", match = { class = "^(discord)$" }, opacity = "0.80 0.80" },
    { name = "appearance-webcord-opacity", match = { class = "^(WebCord)$" }, opacity = "0.80 0.80" },
    { name = "appearance-armcord-opacity", match = { class = "^(ArmCord)$" }, opacity = "0.80 0.80" },
    {
        name = "appearance-vesktop-remove-frosted",
        match = { class = "^(vesktop|Vesktop)$" },
        tag = "-hyprglass_preset_frosted",
    },
    {
        name = "appearance-vesktop-glass",
        match = { class = "^(vesktop|Vesktop)$" },
        tag = "+hyprglass_preset_vesktop_glass",
    },
    {
        name = "appearance-warp-appearance",
        match = { class = "^(app.drey.Warp)$" },
        float = true,
        opacity = "0.80 0.80",
    },
    {
        name = "appearance-protonup-appearance",
        match = { class = "^(net.davidotek.pupgui2)$" },
        float = true,
        opacity = "0.80 0.80",
    },
    { name = "appearance-yad-appearance", match = { class = "^(yad)$" }, float = true, opacity = "0.80 0.80" },
    { name = "appearance-signal-appearance", match = { class = "^(Signal)$" }, float = true, opacity = "0.80 0.80" },
    {
        name = "appearance-planify-appearance",
        match = { class = "^(io.github.alainm23.planify)$" },
        float = true,
        opacity = "0.80 0.80",
    },
    {
        name = "appearance-upscaler-appearance",
        match = { class = "^(io.gitlab.theevilskeleton.Upscaler)$" },
        float = true,
        opacity = "0.80 0.80",
    },
    {
        name = "appearance-video-downloader-opacity",
        match = { class = "^(com.github.unrud.VideoDownloader)$" },
        opacity = "0.80 0.80",
    },
    {
        name = "appearance-gtk-portal-opacity",
        match = { class = "^(org.freedesktop.impl.portal.desktop.gtk)$" },
        opacity = "0.80 0.80",
    },
    {
        name = "appearance-hyprland-portal-opacity",
        match = { class = "^(org.freedesktop.impl.portal.desktop.hyprland)$" },
        opacity = "0.80 0.80",
    },
    {
        name = "appearance-pavucontrol-appearance",
        match = { class = "^(pavucontrol)$" },
        float = true,
        opacity = "0.80 0.70",
    },
    {
        name = "appearance-blueman-appearance",
        match = { class = "^(blueman-manager)$" },
        float = true,
        opacity = "0.80 0.70",
    },
    {
        name = "appearance-nm-applet-appearance",
        match = { class = "^(nm-applet)$" },
        float = true,
        opacity = "0.80 0.70",
    },
    {
        name = "appearance-nm-connection-editor-appearance",
        match = { class = "^(nm-connection-editor)$" },
        float = true,
        opacity = "0.80 0.70",
    },
    {
        name = "appearance-polkit-appearance",
        match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
        float = true,
        opacity = "0.80 0.70",
    },
    { name = "appearance-rofi-opacity", match = { class = "^(Rofi)$" }, opacity = "0.80 0.70" },
    {
        name = "appearance-dolphin-copy-dialog-float",
        match = { class = "^(org.kde.dolphin)$", title = "^(Copying — Dolphin)$" },
        float = true,
    },
    { name = "appearance-picture-in-picture-float", match = { title = "^(Picture-in-Picture)$" }, float = true },
    {
        name = "appearance-firefox-library-float",
        match = { class = "^(firefox)$", title = "^(Library)$" },
        float = true,
    },
    { name = "appearance-vlc-float", match = { class = "^(vlc)$" }, float = true },
    { name = "appearance-eog-float", match = { class = "^(eog)$" }, float = true },
    {
        name = "appearance-video-downloader-float",
        match = { class = "^(com.github.unrud.VideoDownloader)$" },
        float = true,
    },
    {
        name = "appearance-cua-agent-cursor-overlay-no-blur",
        match = { title = "^(Cua\\.AgentCursorOverlay\\..*)$" },
        focus_on_activate = false,
        no_blur = true,
        no_focus = true,
        no_follow_mouse = true,
        no_initial_focus = true,
    },
}

for _, rule in ipairs(window_rules) do
    hl.window_rule(rule)
end

local layer_rules = {
    {
        name = "layer-noctalia",
        match = {
            namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
        },
        no_anim = true,
        ignore_alpha = 0.5,
        blur = true,
        blur_popups = true,
    },
    { name = "layer-rofi-blur", match = { namespace = "rofi" }, blur = true, ignore_alpha = 0 },
    { name = "layer-anyrun-blur", match = { namespace = "anyrun" }, blur = true, ignore_alpha = 0 },
    { name = "layer-gbar-blur", match = { namespace = "gbar" }, blur = true },
    { name = "layer-logout-dialog-blur", match = { namespace = "logout_dialog" }, blur = true },
    {
        name = "layer-swaync-control-center-blur",
        match = { namespace = "swaync-control-center" },
        blur = true,
        blur_popups = true,
        ignore_alpha = 0.7,
        xray = true,
    },
    {
        name = "layer-swaync-notification-window-blur",
        match = { namespace = "swaync-notification-window" },
        blur = true,
        ignore_alpha = 0.7,
    },
    {
        name = "appearance-ghostty-overlay",
        match = { namespace = "ghostty-quick-terminal" },
        blur_popups = false,
        xray = false,
    },
}

for _, rule in ipairs(layer_rules) do
    hl.layer_rule(rule)
end
