import QtQuick 2.15
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: root
    color: "#292929"
    property var table
    property var tablemodel
    property var headers: []
    property var table2
    property var tablemodel2
    property var headers2: []
    property var preCell
    property string hashkeyColName: "___" //hashkey不显示，用于修改数据
    Component {
        id: com_tablemodel
        ListModel {
        }
    }
    Component {
        id: com_table
        MyTable {}
    }
    Component {
        id: com_tvc
        TableViewColumn {
        }
    }
    function fill(d, isPaging = false, tableTip = "") {
        if(!d.datas) {
            return;
        }
        if(isPaging) {
            if(tablemodel) {
                tablemodel.clear();
            }
        } else {
            if(table) {
                table.destroy();
                table = null;
            }
            if(tablemodel) {
                tablemodel.destroy();
                tablemodel = null;
            }
            headers = [];
        }
        if(!tablemodel) {
            tablemodel = com_tablemodel.createObject(root);
        }
        if(!table) {
            table = com_table.createObject(root);
            table.width = root.width;
            table.model = tablemodel;
        }
        table.setTip(tableTip, "["+ d.cost + "mills]");
        if(!isPaging) {
            if(table2) {
                table2.setTip("", "");
            }
        }
//        console.log(":::::::::", JSON.stringify(d));
        for(let i = 0; i < d.datas.length; i++) {
            let it = d.datas[i];
            if(i === 0) {
                if(headers.length === 0) {
                    for(let j = 0; j < it.length; j++) {
                        if(it[j] === hashkeyColName) {
                            continue;
                        }
                        let tvc = table.addColumn(com_tvc);
                        tvc.role = it[j];
                        tvc.title = it[j];
                        tvc.width = 100;
                        headers[headers.length] = it[j];
                    }
                }
            } else {
                let row = {};
                for(let j = 0; j < it.length; j++) {
                    let k = headers[j];
                    if(!k) {
                        k = hashkeyColName;
                    }
                    row[k] = it[j];
                }
                tablemodel.append(row);
            }
        }
        if(isPaging) {
            table.genVerHeader(tablemodel.count);
        }
    }
    function count() {
        return tablemodel?tablemodel.count:0;
    }
    function endRow() {
        if(tablemodel.count < 1) {
            return null;
        }
        return tablemodel.get(tablemodel.count-1);
    }
    function fillSubData(d2,cmd) {
        console.log("fillSubData", JSON.stringify(d2));
        table.width = root.width/2;
        if(table2) {
            table2.destroy();
            table2 = null;
        }
        if(tablemodel2) {
            tablemodel2.destroy();
            tablemodel2 = null;
        }
        headers2 = [];
        if(!tablemodel2) {
            tablemodel2 = com_tablemodel.createObject(root);
        }
        if(!table2) {
            table2 = com_table.createObject(root);
            table2.x = table.width;
            table2.width = root.width/2;
            table2.model = tablemodel2;
            table2.isSub = true;
        }
        table2.setTip(cmd, "");
        tablemodel2.clear();
        if(d2.datas) {
            for(let i = 0; i < d2.datas.length; i++) {
                let it = d2.datas[i];
                if(i === 0) {
                    if(headers2.length === 0) {
                        for(let j = 0; j < it.length; j++) {
                            let tvc = table2.addColumn(com_tvc);
                            tvc.role = it[j];
                            tvc.title = it[j];
                            tvc.width = 100;
                            headers2[headers2.length] = it[j];
                        }
                    }
                } else {
                    let row2 = {};
                    for(let j = 0; j < it.length; j++) {
                        row2[headers2[j]] = it[j];
                    }
                    tablemodel2.append(row2);
                }
            }
        }
    }
    function endSubRow() {
        if(tablemodel2.count < 1) {
            return null;
        }
        return tablemodel2.get(tablemodel2.count-1);
    }
    function getHeaders() {
        return headers;
    }
    function getRows(row) {
        return tablemodel?tablemodel.get(row):null;
    }
    function getCurResultSelectedRows() {
        if(!table) {
            return [];
        }
        return table.getSelectedRows();
    }
    function deleteCurResultSelectedRows() {
        if(!table) {
            return;
        }
        return table.deleteSelectedRows();
    }
}
