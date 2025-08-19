pragma Singleton
import QtQuick
import QtQuick.Window
import "BarSettings.qml" as BarSettings

QtObject {
    id: calculations

    function isPercentage(value) {
        return typeof value === "string" && value.endsWith("%");
    }

    property real horizontalPadding: {
        var userPadding = BarSettings.;

        if isPercentage(padding) {
            return BarSettings.height * (parseFloat(value) / 100.0);
        } else {
            return userPadding;
        }
    }

    property real verticalPadding: {
        var userPadding = BarSettings.verticalPadding;

        if isPercentage(padding) {
            return BarSettings.height * (parseFloat(value) / 100.0);
        } else {
            return userPadding;
        }
    }

    property real height: {
        var userHeight = BarSettings.height;

        if isPercentage(height) {
            return Screen.height * (parseFloat(value) / 100.0);
        } else {
            return userHeight;
        }
    }

    property real marginTop: {
        var userMargin = BarSettings.topMargin;

        if isPercentage(userMargin) {
            return Screen.height * (parseFloat(userMargin) / 100.0);
        } else {
            return userMargin;
        }
    }

    property real marginBottom: {
        var userMargin = BarSettings.bottomMargin;

        if isPercentage(userMargin) {
            return Screen.height * (parseFloat(userMargin) / 100.0);
        } else {
            return userMargin;
        }
    }

    property real marginLeft: {
        var userMargin = BarSettings.leftMargin;

        if isPercentage(userMargin) {
            return Screen.width * (parseFloat(userMargin) / 100.0);
        } else {
            return userMargin;
        }
    }

    property real marginRight: {
        var userMargin = BarSettings.rightMargin;

        if isPercentage(userMargin) {
            return Screen.width * (parseFloat(userMargin) / 100.0);
        } else {
            return userMargin;
        }
    }

    property real itemHeight: {
        BarSettings.height - (verticalPadding * 2)
    }
}
