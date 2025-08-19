import QtQuick
import Quickshell
import Quickshell.Hyprland

import "../../../Theme.qml" as Theme
import "../../../utils/calculations.qml" as Calculations
import "../../../MainSettings.qml" as MainSettings
import "../../utils/barCalculations.qml" as BarCalculations
import "../../BarSettings.qml" as BarSettings

PanelWindow {
    id: panel

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: BarCalculations.height

    margins {
        top: BarCalculations.marginTop
        bottom: BarCalculations.marginBottom
        left: BarCalculations.marginLeft
        right: BarCalculations.marginRight
    }

    Rectangle {
        id: bar

        radius: 8
        anchors.fill: parent
        color: Calculations.background

        Row {
            id: workspacesRow

            spacing: BarCalculations.horizontalPadding

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: BarCalculations.horizontalPadding * 2
            }

            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    width: BarCalculations.itemWidth
                    height: parent.height
                    radius: 5
                    color: Theme.accentRed
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspaces " + modelData.id)
                }

                Text {
                    text: modelData.id
                    anchors.centerIn: parent
                    color: Calculations.foreground
                    font.pixelSize: MainSettings.fontSize
                    font.family: MainSettings.fontFamily
                }

                Text {
                    visible: Hyprland.workspaces.length === 0
                    text: "No workspaces"
                    color: Calculations.foreground
                    font.pixelSize: MainSettings.fontSize
                    font.family: MainSettings.fontFamily
                }
            }

            Text {
                id: timeDisplay

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: BarCalculations.horizontalPadding * 2
                }

                property string curretTime: ""

                text: curretTime
                color: Calculations.foreground
                font.pixelSize: MainSettings.fontSize
                font.family: MainSettings.fontFamily

                // Update the time every second
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {
                        var now = new Date();
                        timeDisplay.curretTime = Qt.formatDate(now, "MMM:dd") + " " + Qt.formatDate(now, "hh:mm:ss");
                    }
                }

                Component.onCompleted: {
                    var now = new Date();
                    curretTime = Qt.formatDate(now, "MMM:dd") + " " + Qt.formatDate(now, "hh:mm:ss");
                }
            }
        }
    }
}
