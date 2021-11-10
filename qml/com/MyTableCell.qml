import QtQuick 2.15
import QtQuick.Controls 1.4

Rectangle {
    color: styleData.selected ? "#000000" : "#292929"
    clip: true
    property int st: 0
    onStChanged: {
        color = st ? "#000000" : "#292929";
    }
    TextField {
//            TextEdit {
        id: tf
        x: 3
//                color: "#eaeaea"
        textColor: "#eaeaea"
        readOnly: true
        selectByMouse: true
        text: styleData.value
        width: parent.width
        height: parent.height
        horizontalAlignment: TextInput.AlignLeft
        verticalAlignment: TextInput.AlignVCenter
        style: com_tfs
        Keys.onReturnPressed: {
            tf.recover();
            submitCell(styleData.row, styleData.column, styleData.value, tf.text, root.parent.getHeaders(), root.parent.getRows(styleData.row));
        }
        MouseArea {
            id: ma
            anchors.fill: parent
            propagateComposedEvents: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {
                if(preEditCell) {
                    preEditCell.recover();
                }
                if(preCell) {
                    preCell.parent.st = 0;
                }
                tf.parent.st = tf.parent.st ? 0 :1;
                preCell = tf;
                if(mouse.button === Qt.LeftButton) {
                    if(!root.isSub) {
                        clickTableCell(styleData.row, styleData.column, styleData.value);
                    }
                } else {
                    copy(styleData.value);
                }
            }
            onDoubleClicked: {
                tf.goEdit();
            }
        }
        function recover() {
            tf.readOnly = true;
            ma.visible = true;
        }
        function goEdit() {
            if(preEditCell) {
                preEditCell.recover();
            }
            tf.readOnly = false;
            ma.visible = false;
            preEditCell = tf;
        }
    }
    Rectangle {
        x: parent.width-1
        width: 1
        height: parent.height
        color: "white"
    }
    Rectangle {
        y: parent.height-1
        width: parent.width
        height: 1
        color: "white"
    }
}
