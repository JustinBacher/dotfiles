//@pragma UseQApplication

import QtQuick
import Quickshell
import "./bar/modules/bar/"

ShellRoot {
    id: root

    Loader {
        active: true
        sourceComponent: Bar{}
    }
}
