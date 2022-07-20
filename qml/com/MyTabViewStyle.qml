import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import "../ui.js" as UI

TabViewStyle {
    frameOverlap: 1
    property bool closeBtnVisable: true
    tab: Rectangle {
        color: styleData.selected ? "#000000" :"#393939"
        border.color:  "#191919"
        implicitWidth: Math.max(text.width + 10, 80)
        implicitHeight: UI.height2
        Text {
            id: text
            anchors.centerIn: parent
            text: styleData.title
            color: styleData.selected ? "white" : "black"
        }
        Btn {
            id: btn_close
            visible: closeBtnVisable && styleData.index > 0
            text: "x"
            text_size: 12
            text_color: "white"
            color: "transparent"
            hover_color: "#696969"
            width: 15
            height: width
            x: parent.width-width
            function click() {
                if(styleData.index === 0) {
                    return;
                }
                if(tabView.count > 1) {
                    tabView.removeTab(styleData.index);
                }
            }
        }
    }
//            frame: Rectangle { color: "steelblue" }
}
