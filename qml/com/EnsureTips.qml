import QtQuick 2.0
import QtQuick.Controls 2.12

Popup {
    id: root
    width: 200
    height: 120
    x: parent.width/2-width/2
    y: parent.height/2-height/2
    modal: true
    focus: true
    background: Rectangle{color:"transparent"}

    property alias text: popup_text.text
    property var onSure

    Rectangle {
        anchors.fill: parent
        focus: true
        color: "#191919"
        radius: 5
        clip: true
        Column {
            anchors.centerIn: parent
            spacing: 20
            Text {
                id: popup_text
                font.pointSize: 14
                color: "#acacac"
            }
            Row {
                spacing: 20
                MyBtn {
                    z:10
                    text_size: 12
                    text_color: "#393939"
                    text: "确定"
                    width: 45
                    height: 20
                    color: "white"
                    function click() {
                        onSure(true);
                        root.close();
                    }
                }
                MyBtn {
                    z:10
                    text_size: 12
                    text_color: "#393939"
                    text: "取消"
                    width: 45
                    height: 20
                    color: "white"
                    function click() {
                        onSure(false);
                        root.close();
                    }
                }
            }
        }
        Keys.onReturnPressed: {
            onSure(true);
            root.close();
        }
    }
    onVisibleChanged: {
        if(visible){
            root.forceActiveFocus();
        } else {
            onSure(false);
            root.close();
        }
    }
}
