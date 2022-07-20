import QtQuick 2.15
import QtQuick.Controls 1.4
import "../ui.js" as UI

Rectangle {
    id: root
    property bool isSub: false
    property alias model: tableview.model
    property alias tableTip1: tip1.text
    property alias tableTip2: tip2.text
    property var preEditCell
    height: parent.height
    color: "transparent"
    property int selectedIndex: -1
    Rectangle {
        id: tableTip
        x: vh.width
        width: parent.width - x - 10
        height: tip1.height
        color: "transparent"
        Text {
            id: tip1
            height: UI.height3
            color: UI.color_gray1
            font.pointSize: UI.font_size_title4
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: tip2.width + 10
        }
        Text {
            id: tip2
            height: UI.height3
            color: UI.color_gray1
            font.pointSize: UI.font_size_title5
            verticalAlignment: Text.AlignVCenter
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    MyVerticalHeader {
        id: vh
        y: UI.height1 + tableTip.height
        totalRow: tableview.model?tableview.model.count:0
    }
    Connections {
        target: vh
        function onClick(index) {
            selectedIndex = index;
            let m = tableview.model;
            if(tableview.selection.contains(index)) {
                tableview.selection.deselect(index);
            } else {
                tableview.selection.select(index);
            }
        }
    }
    Component {
        id: com_footer
        MyTableFooter {
        }
    }
    Component{
        id: com_tfs
        MyTextFieldStyle{
        }
    }
    Component {
        id: com_cell
        MyTableCell {
        }
    }
    Component {
        id: com_header
        MyTableHeader {
        }
    }
    TableView {
        id: tableview
        y: tableTip.height
        x: vh.width
        width: parent.width-vh.width
        height: parent.height-tableTip.height
        sortIndicatorVisible: true
        clip: true
        headerDelegate: com_header
        contentFooter: isSub ? com_footer : null
        itemDelegate:  com_cell
        rowDelegate: Rectangle {
            color: "#292929"
            height: UI.height3
        }
        onClicked: {
            if(preCell) {
                preCell.parent.st = 0;
            }
        }
        flickableItem.onContentYChanged: {
            vh.syncContentY(flickableItem.contentY+UI.height1);
        }
    }
    function addColumn(com) {
        return tableview.addColumn(com);
    }
    function genVerHeader(count) {
        tableview.flickableItem.contentY = -16;
        return vh.genVerHeader(page-1, count);
    }
    function getSelectedRows() {
        let arr = [];
        tableview.selection.forEach(function(i) {
            arr[arr.length] = tableview.model.get(i);
        });
        return arr;
    }
    function deleteSelectedRows() {
        tableview.selection.forEach(function(i) {
            tableview.model.remove(i);
        });
    }
    function setTip(tip1, tip2) {
        root.tableTip1 = tip1;
        root.tableTip2 = tip2;
    }
}
