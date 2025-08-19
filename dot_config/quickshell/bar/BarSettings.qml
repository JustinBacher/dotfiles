import QtQuick

QtObject {
    id: settings

    //  ▗▄▄▖▗▄▄▄▖▗▖  ▗▖▗▄▄▄▖▗▄▄▖  ▗▄▖ ▗▖   
    // ▐▌   ▐▌   ▐▛▚▖▐▌▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌   
    // ▐▌▝▜▌▐▛▀▀▘▐▌ ▝▜▌▐▛▀▀▘▐▛▀▚▖▐▛▀▜▌▐▌   
    // ▝▚▄▞▘▐▙▄▄▖▐▌  ▐▌▐▙▄▄▖▐▌ ▐▌▐▌ ▐▌▐▙▄▄▖

    property var height: 50.0 // Can be in percentage (of screen) or pixels
    property real radius: 5

    // ▗▄▄▄▖▗▄▄▄▖▗▄▄▄▖▗▖  ▗▖ ▗▄▄▖
    //   █    █  ▐▌   ▐▛▚▞▜▌▐▌   
    //   █    █  ▐▛▀▀▘▐▌  ▐▌ ▝▀▚▖
    // ▗▄█▄▖  █  ▐▙▄▄▖▐▌  ▐▌▗▄▄▞▘

    property var horizontalPadding: "5%" // Can be in percentage (of bar) or pixels
    property var verticalPadding: "5%" // Can be in percentage (of bar) or pixels
    property var itemWidth: "30%" // Can be in percentage (of bar) or pixels

    // ▗▖  ▗▖ ▗▄▖ ▗▄▄▖  ▗▄▄▖▗▄▄▄▖▗▖  ▗▖ ▗▄▄▖
    // ▐▛▚▞▜▌▐▌ ▐▌▐▌ ▐▌▐▌     █  ▐▛▚▖▐▌▐▌   
    // ▐▌  ▐▌▐▛▀▜▌▐▛▀▚▖▐▌▝▜▌  █  ▐▌ ▝▜▌ ▝▀▚▖
    // ▐▌  ▐▌▐▌ ▐▌▐▌ ▐▌▝▚▄▞▘▗▄█▄▖▐▌  ▐▌▗▄▄▞▘

    property var topMargin: 8 // Can be in percentage (of screen) or pixels
    property var bottomMargin: 8 // Can be in percentage (of screen) or pixels
    property var leftMargin: 8 // Can be in percentage (of screen) or pixels
    property var rightMargin: 8 // Can be in percentage (of screen) or pixels

    // ▗▄▄▄▖ ▗▄▖ ▗▖  ▗▖▗▄▄▄▖
    // ▐▌   ▐▌ ▐▌▐▛▚▖▐▌  █  
    // ▐▛▀▀▘▐▌ ▐▌▐▌ ▝▜▌  █  
    // ▐▌   ▝▚▄▞▘▐▌  ▐▌  █  

    property int fontSize: 12
    property font fontFamily: "Maple Mono"

}
