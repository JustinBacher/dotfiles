pragma Singleton
import QtQuick
import "../../Settings.qml" as Settings

QtObject {
    id: calculations

    property color background: {
        var defaultBackground = Settings.background;

        if typeof Settings.background === undefined {
            Qt.rgba(0,0,0,1);
        }

        switch (Settings.theme.toLowerCase()) {
            case "dark":
                return typeof Settings.darkBackground === undefined ?
                    defaultBackground :
                    Settings.darkBackground;
            case "light":
                return typeof Settings.lightBackground === undefined ?
                    defaultBackground :
                    Settings.lightBackground;

            default:
                return defaultBackground;
        }
    }

    property color foreground: {
        var defaultForeground = Settings.background;

        if typeof Settings.foreground === undefined {
            defaultforeground = Qt.rgba(255,255,255,1);
        }

        switch (Settings.theme.toLowerCase()) {
            case "dark":
                return typeof Settings.darkforeground === undefined ?
                    defaultForeground :
                    Settings.darkForeground;
            case "light":
                return typeof Settings.lightForeground === undefined ?
                    defaultForeground :
                    Settings.lightForeground;

            default:
                return defaultforeground;
        }
    }
}
