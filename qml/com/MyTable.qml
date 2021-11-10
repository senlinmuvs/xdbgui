import QtQuick 2.15
import QtQuick.Controls 1.4

Rectangle {
    id: root
    property bool isSub: false
    property alias model: tableview.model
    property alias tableTip: tableTip.text
    property var preEditCell
    height: parent.height
    color: "transparent"
    property int selectedIndex: -1
    Text {
        id: tableTip
        height: 20
        color: "#9a9a9a"
        font.pointSize: 14
        verticalAlignment: Text.AlignVCenter
        x: 5
    }
    MyVerticalHeader {
        id: vh
        anchors.top: tableview.top
        anchors.topMargin: 16
        anchors.left: parent.left
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
            height: 30
        }
        onClicked: {
            if(preCell) {
                preCell.parent.st = 0;
            }
        }
        flickableItem.onContentYChanged: {
            vh.syncContentY(flickableItem.contentY+16);
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
}
