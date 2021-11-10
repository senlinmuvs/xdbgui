import QtQuick 2.0

Rectangle {
    id: root
    color: "#000000"
    height: col.height
    property int from: 0
    property int totalRow: 0
    property int pageSize: 0
    width: 16*(String(totalRow).length)
    property int h: 30
    clip: true
    signal click(int index)
    Column {
        id: col
        width: parent.width
        Repeater {
            id: rep
            model: totalRow
            Rectangle {
                width: parent.width
                height: h
                color: ma.pressed ? "#393939" : "transparent"
                Text {
                    text: from+index+1
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    color: "white"
                    width: parent.width - 2
                    height: parent.height
                }
                Rectangle {
                    y: parent.height
                    width: parent.width
                    height: 1
                    color: "white"
                }
                MouseArea {
                    id: ma
                    anchors.fill: parent
                    onClicked: {
                        click(index);
                    }
                }
            }
        }
    }
    function syncContentY(y) {
        col.y = -y;
    }
    function genVerHeader(page, count) {
        if(pageSize === 0) {
            pageSize = totalRow;
        }
        if(count > 0) {
            rep.model = 0;
            from = page * pageSize;
            rep.model = totalRow;
        } else {
            totalRow = 0;
            from = 0;
            rep.model = 0;
        }
    }
    function clearVerHeader() {
        pageSize = 0;
        totalRow = 0;
        from = 0;
        rep.model = 0;
    }
}
