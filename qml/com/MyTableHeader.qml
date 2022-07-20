import QtQuick 2.0
import "../ui.js" as UI

Rectangle {
    color: "#000000"
    width: 100
    height: UI.height1
    clip: true
    Text {
        color: "white"
        font.pointSize: UI.font_size_title2
        text: styleData.value
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    Rectangle {
        x: parent.width-1
        width: 1
        height: parent.height
        color: "white"
    }
}
