import QtQuick 2.15

Rectangle {
    color: "transparent"
    height: 20
    width: parent.width
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height
        spacing: 10
        Btn {
            width: 40
            height: parent.height
            text: "<"
            text_bold: true
            text_color: "white"
            text_size: 16
            hover_color: "#393939"
            color: "transparent"
            function click() {
                console.log("previous page");
                preSubPage();
            }
        }
        Btn {
            width: 40
            height: parent.height
            text: ">"
            text_bold: true
            text_color: "white"
            text_size: 16
            hover_color: "#393939"
            color: "transparent"
            function click() {
                console.log("next page");
                nextSubPage();
            }
        }
    }
}
