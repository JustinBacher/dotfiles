pragma Singleton
import QtQuick

QtObject {
    // --- Base Tokyo Night Palette ---
    // These are the core colors that define the Tokyo Night aesthetic.
    // Sourced from common Tokyo Night implementations (e.g., VS Code themes, dotfiles)

    // Backgrounds
    property color darkBackground: "#1a1b26" // Main very dark background
    property color background: "#1f2335"     // Slightly lighter background (e.g., for panels)
    property color lightBackground: "#24283b" // Even lighter, for elements like popups, tooltips

    // Foreground / Text
    property color foreground: "#a9b1d6"     // Main text color (light blue-grey)
    property color lightForeground: "#c0caf5" // Lighter text, for emphasis
    property color darkerForeground: "#828393" // Darker text, for secondary info, comments

    // Accent Colors
    property color accentBlue: "#7aa2f7"     // Main blue accent
    property color accentPurple: "#bb9af7"   // Purple accent
    property color accentGreen: "#9ece6a"    // Green accent
    property color accentYellow: "#e0af68"   // Yellow/Orange accent
    property color accentRed: "#f7768e"      // Red accent
    property color accentCyan: "#7dcfff"     // Cyan accent
    property color accentMagenta: "#ff77ff"  // Magenta accent (less common but present)

    // --- UI Component Specific Colors & Properties ---
    // These are derived or common UI elements, making it easier to apply the theme.

    // General UI Elements
    property color primaryButtonBackground: accentBlue
    property color primaryButtonForeground: background // Or foreground if contrast is too low
    property color secondaryButtonBackground: lightBackground
    property color secondaryButtonForeground: foreground

    property color border: darkerForeground // For subtle borders
    property color selectionBackground: Qt.rgba(accentBlue.r, accentBlue.g, accentBlue.b, 0.2) // Semi-transparent blue for selections
    property color selectionForeground: foreground

    property color successColor: accentGreen
    property color warningColor: accentYellow
    property color errorColor: accentRed

    // States
    property color hoveredColor: Qt.lighter(background, 1.1) // Slightly lighter on hover
    property color pressedColor: Qt.darker(background, 1.1)  // Slightly darker when pressed

    function primaryColor(isDark) {
        return isDark ? darkBackground : lightForeground;
    }
}
