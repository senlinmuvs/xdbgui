import QtQuick 2.0

Rectangle {
    color: "#000000"
    width: 100
    height: 16
    clip: true
    Text {
        color: "white"
        font.pixelSize: 12
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
