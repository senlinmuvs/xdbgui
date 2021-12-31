import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import XDB.Tree 1.0
import "com"
import "com/com.js" as Com

Window {
    id: root
    width: 1000
    height: 800
    visible: true
    color: "#191919"
    property var cbs: {0:null} // all call back
    property int cbid: 0
    property int curConnRow: -1
    property int ctrlVal:Qt.ControlModifier;
    property string ctrlName:$app.getPlatform() === Com.platform_mac ? "Cmd" : "Ctrl";
    property var cmdHistoryArr: [] //next page时追加,执行新命令清空
    property string curCmd: ""
    property var curTabCmd: []
    property var curTabSubCmd: []
    property string preQuery1Cont: ""
    property var subCmdHistoryArr: [] //next page时追加,执行新命令清空
    property int page: 0

    Rectangle {
        id: toolbar
        width: parent.width
        height: 30
        color: "transparent"
        Row {
            x: 5
            width: parent.width - 10
            height: parent.height
            spacing: 10
            Text {
                text: "XDB"
                color: "white"
                font.bold: true
                font.pointSize: 12
                width: 50
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Rectangle {
                width: 1
                height: parent.height - 16
                y: 8
                color: "white"
            }
            Btn {
                width: 40
                height: parent.height
                text: "+"
                text_bold: true
                text_color: "white"
                text_size: 23
                hover_color: "#393939"
                color: "transparent"
                function click() {
                    $app.openAddConnDialog();
                }
            }
            Rectangle {
                width: 1
                height: parent.height - 16
                y: 8
                color: "white"
            }
            BtnImg {
                id: btn_onoff
                property int st: 0
                imgWidth: 23
                imgHeight: parent.height - 6
                y: -2
                src: "qrc:/assets/icon_off.png"
                radius: 1
                hover_color: "#393939"
                onStChanged: {
                    if(st === 1) {
                        src = "qrc:/assets/icon_on.png";
                    } else {
                        src = "qrc:/assets/icon_off.png";
                    }
                }
                function click() {
                    connOnOrOff(st);
                }
            }
            Rectangle {
                width: 1
                height: parent.height - 16
                y: 8
                color: "white"
            }
            BtnImg {
                id: btn_edit
                imgWidth: 23
                imgHeight: parent.height - 6
                y: -2
                src: "qrc:/assets/icon_edit.png"
                radius: 1
                hover_color: "#393939"
                function click() {
                    let n = treemodel.getNodeByIndex(treeView.currentIndex);
                    if(treeView.currentIndex.parent.row >= 0) {
                        n.st = 1;
                        treeView.preIndex = treeView.currentIndex;
                    } else {
                        $app.editConn(n.id);
                    }
                }
            }
            Rectangle {
                width: 1
                height: parent.height - 16
                y: 8
                color: "white"
            }
            BtnImg {
                id: btn_del
                imgWidth: 23
                imgHeight: parent.height - 6
                y: -2
                src: "qrc:/assets/icon_del.png"
                radius: 1
                hover_color: "#393939"
                function click() {
                    ensure("确定删除？", function(y){
                        if(y) {
                            let n = treemodel.getNodeByIndex(treeView.currentIndex);
                            $app.del(n.id, fu(function(r) {
                                let st = treemodel.delNode(treeView.currentIndex);
                                if(st === 1) {
                                    alert(qsTr("Exists Children, can't Delete!"));
                                }
                            }));
                        }
                    });
                }
            }
            Rectangle {
                width: 1
                height: parent.height - 16
                y: 8
                color: "white"
            }
            BtnImg {
                id: btn_start
                imgWidth: 23
                imgHeight: parent.height - 8
                y: -2
                src: "qrc:/assets/icon_start.png"
                radius: 1
                hover_color: "#393939"
                function click() {
                    let cmd = getCurrentSelectedText();
                    if(cmd) {
                        exeCmd(cmd);
                    }
                }
            }
            Rectangle {
                width: 1
                height: parent.height - 16
                y: 8
                color: "white"
            }
            BtnImg {
                id: btn_col
                imgWidth: 23
                imgHeight: parent.height - 8
                y: -2
                src: "qrc:/assets/icon_col.png"
                radius: 1
                hover_color: "#393939"
                function click() {
                    let cmd = getCurrentSelectedText();
                    if(cmd) {
                        colCmd(cmd);
                    }
                }
            }
            Rectangle {
                width: 1
                height: parent.height - 16
                y: 8
                color: "white"
            }
            Btn {
                width: 40
                height: parent.height
                text: "<"
                text_bold: true
                text_color: "white"
                text_size: 20
                hover_color: "#393939"
                color: "transparent"
                function click() {
                    console.log("previous page");
                    prePage();
                }
            }
            Rectangle {
                width: 1
                height: parent.height - 16
                y: 8
                color: "white"
            }
            Btn {
                width: 40
                height: parent.height
                text_bold: true
                text: ">"
                text_color: "white"
                text_size: 20
                hover_color: "#393939"
                color: "transparent"
                function click() {
                    console.log("next page");
                    nextPage();
                }
            }
            Rectangle {
                width: 1
                height: parent.height - 16
                y: 8
                color: "white"
            }
            BtnImg {
                id: btn_delrow
                imgWidth: 20
                imgHeight: parent.height - 8
                y: -2
                src: "qrc:/assets/icon_del2.png"
                radius: 1
                hover_color: "#393939"
                function click() {
                    let rows = getCurResultSelectedRows();
                    console.log("del row", JSON.stringify(rows));
                    if(rows.length > 0) {
                        ensure("确定删除选中行？", function(y) {
                            if(y) {
                                deleteRows(rows);
                            }
                        });
                    }
                }
            }
            Rectangle {
                width: 1
                height: parent.height - 16
                y: 8
                color: "white"
            }
        }
        Rectangle {
            y: parent.height - 1
            color: "#4c4c4c"
            width: parent.width
            height: 1
        }
    }
    Component {
        id: com_treeElement
        TreeElement {
            property string name: ""
            property string alias: ""
            property int st: 0 // 0 文本 1 编辑
            property int id: 0
            property int connSt: 0 // 0 未连接 1 已连接
        }
    }
    TreeModel {
        id: treemodel
        roles: ["name"]
    }
    TreeView {
        id: treeView
        y: toolbar.height
        width: 200
        height: parent.height - toolbar.height
        model: treemodel
        property var preIndex
        TableViewColumn {
            title: "DB"
            role: "name"
            width: 200
        }
        onDoubleClicked: {
            if(treeView.currentIndex.parent.row < 0) {
                if(treeView.isExpanded(treeView.currentIndex)) {
                    treeView.collapse(treeView.currentIndex);
                } else {
                    treeView.expand(treeView.currentIndex);
                }
            } else {
                let n = treemodel.getNodeByIndex(treeView.currentIndex);
                let cmd = n.name;
                setCurrentNodeToQueryEditor(cmd);
                exeCmd(cmd);
            }
        }
        onClicked: {
            if(preIndex) {
                let n = treemodel.getNodeByIndex(preIndex);
                if(n) {
                    n.st = 0;
                }
            }
        }
        onPressAndHold: {}
        style: com_treeStyle
        MouseArea {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 10
            hoverEnabled: true
            property int startX:0
            onPressed:{
                startX = mouse.x
            }
            onReleased: {
                startX = 0
//                $app.set($app.ENV_K_LAST_BOOK_LEFT_WIDTH, Math.floor(work_list.width));
            }
            onPositionChanged:{
                if(startX > 0){
                    let left = mouse.x < startX;
                    if(left){
                        let delta = startX - mouse.x
                        treeView.width = Com.max(100,treeView.width - delta);
                    } else {
                        let delta = mouse.x - startX
                        treeView.width = Com.min(root.width/3*2,treeView.width + delta);
                    }
//                    $app.setUIVal(1, note_list.width);
                }
            }
            onEntered: {
                cursorShape = Qt.SizeHorCursor
            }
            onExited: {
                cursorShape = Qt.ArrowCursor
            }
        }
    }
    Component {
        id: com_treeStyle
        TreeViewStyle {
            headerDelegate: Rectangle {
                color: "#000000"
                width: 100
                height: 16
                Text {
                    color: "white"
                    font.pixelSize: 12
                    text: styleData.value
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            itemDelegate: Rectangle {
                color: "transparent"
                Text {
                    id: tt
                    text: getNodeText(styleData.index, styleData.value)
                    color: styleData.index.parent.row >= 0 || isNodeConnected(styleData.index) ? "white" : "#989898"
                    font.bold: (styleData.index.parent.row < 0 && isNodeConnected(styleData.index)) ? true : false
                    width: parent.width
                    height: parent.height
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    visible: !isNodeEditing(styleData.index)
                }
                TextField {
                    id: tf
                    visible: isNodeEditing(styleData.index)
                    text: styleData.value
                    width: parent.width
                    height: parent.height
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    style: TextFieldStyle {
                        textColor: "white"
                        background: Rectangle {
                            color: "transparent"
                        }
                    }
                    Keys.onReturnPressed: {
                        let n = treemodel.getNodeByIndex(styleData.index);
                        let name = tf.text;
                        $app.edit(n.id, name, fu(function(r){
                            n.name = name;
                            n.st = 0;
                            tt.text = name;
                        }));
                    }
                }
            }
            rowDelegate: Rectangle {
                color: styleData.selected ? "#696969" : "transparent"
                height: 30
            }
        }
    }
    Component {
        id: com_tab
        MyTab {}
    }
    TabView {
        id: tabView
        anchors.fill: parent
        anchors.leftMargin: treeView.width
        anchors.topMargin: toolbar.height
        style: MyTabViewStyle{}
        MyTab {}
    }
    Btn {
        x: parent.width - width
        y: toolbar.height
        width: 25
        height: width
        text: "+"
        text_color: "white"
        text_size: 23
        color: "transparent"
        hover_color: "#393939"
        function click() {
            let c = tabView.count;
//            let tab = tabView.addTab("Query"+(c+1));
            let tab = com_tab.createObject(tabView);
            tab.title = "Query"+(c+1);
            tabView.currentIndex = c;
        }
    }
    Tips {
        id: tips
        z: 10
    }
    EnsureTips {
        id: e_ensure
    }
    Timer {
        id: timer
        repeat: true
        interval: 5000
        triggeredOnStart: false
        onTriggered: {
            let txt = getQuery1Text();
            if(txt !== preQuery1Cont) {
                $app.setKV(Com.K_Query1, txt, fu(function(r){
                    console.log("setKV done", r);
                }));
                preQuery1Cont = txt;
            }
        }
    }

    Component.onCompleted: {
        timer.start();
        $app.getTree(fu(function(r){
//            console.log(JSON.stringify(r));
            for(let i = 0; i < r.length; i++) {
                let d = r[i];
                let te = com_treeElement.createObject(treemodel);
                te.id = d.id;
                te.name = d.name;
                te.alias = d.alias;
                if(d.pid < 0) {
                    treemodel.insertNode(te);
                } else {
                    let parent = treemodel.index(d.pid, 0);
                    treemodel.insertNode(te, parent);
                }
            }
        }));

        ////////////////////////////////
        let ctrl = $app.getCtrl();
        if(ctrl.toLowerCase() === "ctrl" || ctrl.toLowerCase() === "cmd") {
            ctrlVal = Qt.ControlModifier;
        } else if(ctrl.toLowerCase() === "meta") {
            ctrlVal = Qt.MetaModifier;
            //qt中的meta对应mac的ctrl
            ctrlName = $app.getPlatform() === Com.platform_mac ? "Ctrl" : "Meta";
        }
        ////////////////////////////////

        $app.getKV(Com.K_Query1, fu(function(v){
            setQuery1Text(v);
        }));
    }
    function onCallback(k, param) {
        let t1 = new Date().getTime();
        let func = cbs[k];
        if(func) {
            func(param);
            delete cbs[k];
        }
        let t2 = new Date().getTime();
        if(Com.isDebug) {
            let len = Object.keys(cbs).length;
            if(Com.isDebug) {
                Com.trace("open detail cost", t2 - t1, "mills.", "callback queue len", len);
            }
        }
    }
    function onPush(ty, d) {
//      console.log(ty, "onPush", JSON.stringify(d));
        if(ty === Com.Push_Add_Conn) {
            let n = treemodel.getNodeByIndex(treemodel.index(root.curConnRow, 0));
            if(n) {
                closeConn(n);
            }
            let te = com_treeElement.createObject(treemodel);
            te.id = d.id;
            te.name = d.name;
            te.alias = d.alias;
            treemodel.insertNode(te);
            //
            let ind = treemodel.getIndexByNode(te);
            for(let i = 0; i < Com.DEF_CMDS.length; i++) {
                colCmd(Com.DEF_CMDS[i], ind);
            }
            //
            conn(te, ind.row);
        } else if(ty === Com.Push_ConnErr) {
            if(root.curConnRow >= 0) {
                let n = treemodel.getNodeByIndex(treemodel.index(root.curConnRow, 0));
                conn(n, root.curConnRow);
            }
        } else if(ty === Com.Push_Edit_Conn) {
            let n = treemodel.getNodeByIndex(treemodel.index(root.curConnRow, 0));
            if(n) {
                closeConn(n);
            } else {
                n = getNodeById(d.id);
            }
            if(!n) {
                return;
            }
//            console.log(JSON.stringify(d));
            n.name = d.name;
            n.alias = d.alias;
            conn(n, root.curConnRow);
        }
    }
    function dp(n) {
        return n;
    }
    function sp(n) {
        return n;
    }
    function fu(cb) {
        let i = root.cbid;
        root.cbs[i] = cb;
        root.cbid++;
        return i;
    }
    function getCurrentSelectedText() {
        let tab = tabView.getTab(tabView.currentIndex);
        let txt = tab.getSelectedText();
        return txt;
    }
    function setCurrentNodeToQueryEditor(name) {
        let tab = tabView.getTab(tabView.currentIndex);
        tab.setCurrentNodeToQueryEditor(name);
    }
    function alert(msg, autoclose=true, cb=null) {
        tips.popup(msg, autoclose, cb);
    }
    function ensure(msg, cb) {
        e_ensure.text = msg;
        e_ensure.onSure = cb;
        e_ensure.open();
    }
    //
    function connOnOrOff(st) {
        let curConnIndex = treeView.currentIndex;
        if(curConnIndex.parent.row >= 0) {
            curConnIndex = treeView.currentIndex.parent;
        }
        if(curConnIndex.row < 0) {
            return;
        }
        let n = treemodel.getNodeByIndex(curConnIndex);
        if(btn_onoff.st === 0) {
            conn(n, curConnIndex.row);
        } else {
            if(n.connSt === 1 || (treemodel.rowCount() === 1 && n.connSt === 0)) {
                closeConn(n);
            }
        }
    }
    function conn(n, row) {
        $app.conn(n.id, fu(function(r) {
            btn_onoff.st = 1;
            n.connSt = 1;
            root.curConnRow = row;
        }));
    }
    function closeConn(n) {
        $app.closeConn();
        btn_onoff.st = 0;
        n.connSt = 0;
        root.curConnRow = -1;
    }
    function exeCmd(cmd,isPaging=false, direction=0) {
        if(!cmd) {
            return;
        }
        if(!isPaging) {
            cmdHistoryArr = [];
            page = 0;
        }
        console.log(cmd);
        root.curCmd = cmd;
        Com.fillArr(curTabCmd, tabView.currentIndex, "");
        root.curTabCmd[tabView.currentIndex] = cmd;
        $app.exe(cmd, fu(function(r) {
            let d = JSON.parse(r);
            if(d.err) {
                alert(d.err);
            } else {
                if(direction === 0) {
                    page++;
                } else if(direction === 1) {
                    page--;
                }
                let tab = tabView.getTab(tabView.currentIndex);
                tab.fill(d,isPaging,cmd);
                //执行完发现结果为空，则去掉刚刚添加进去的历史命令记录
                if(direction === 0 && cmdHistoryArr.length > 0 && !d.datas) {
                    cmdHistoryArr.splice(cmdHistoryArr.length-1, 1);
                }
            }
        }));
        return;
    }
    function exeSubCmd(cmd) {
        if(!cmd) {
            return;
        }
        console.log(cmd);
        Com.fillArr(curTabSubCmd, tabView.currentIndex, "");
        root.curTabSubCmd[tabView.currentIndex] = cmd;
        $app.exe(cmd, fu(function(r) {
            let d = JSON.parse(r);
            if(d.err) {
                alert(d.err);
            } else {
                let tab = tabView.getTab(tabView.currentIndex);
                tab.fillSubData(d, cmd);
            }
        }));
    }
    function colCmd(cmd, ind) {
        if(treemodel.rowCount() === 0) {
            return;
        }
        if(!ind) {
            ind = treeView.currentIndex;
        }
        if(ind.row < 0) {
            ind = treemodel.index(0, 0);
        }
        if(ind.parent.row >= 0) {
           ind = ind.parent;
        }
        let te = com_treeElement.createObject(treemodel);
        te.name = cmd;
        treemodel.insertNode(te, ind);
        $app.collecting(cmd, ind.row, fu(function(r){
//            console.log(JSON.stringify(r));
            te.id = r.id;
        }));
    }
    property var pressedLst: 0
    function onQueryEditorKeysPressed(txt, event, cursor, selectedText) {
        let cur = new Date().getTime();
        if(pressedLst > 0 && cur - pressedLst < 100) {
//            console.log(">>>>>>>>>>>>>>>>>>>>>>>>>", pressedLst, cur, cur-pressedLst);
            return;
        }
        pressedLst = cur;
        //
        if(event.modifiers === ctrlVal && event.key === Qt.Key_Return) {
            if(selectedText) {
                exeCmd(selectedText);
//            } else {
////                console.log(">>>>>", cursor, txt.length);
//                let cmd = "";
//                for(let i = cursor; i >= 0; i--) {
//                    if(txt[i] === '\n') {
//                        cmd = txt.substring(i, cursor);
//                        break;
//                    }
//                }
//                if(cursor > 0 && !cmd) {
//                    cmd = txt;
//                }
//                if(cmd) {
//                    exeCmd(cmd.trim());
//                }
            }
        } else if(event.modifiers === (ctrlVal|Qt.AltModifier) && event.key === Qt.Key_C) {
            colCmd(selectedText);
        } else if(event.modifiers === ctrlVal && event.key === Qt.Key_PageDown) {
            if(tabView.currentIndex+1<tabView.count) {
                tabView.currentIndex++;
                tabView.getTab(tabView.currentIndex).setFocus();
            }
        } else if(event.modifiers === ctrlVal && event.key === Qt.Key_PageUp) {
            if(tabView.currentIndex-1>=0) {
                tabView.currentIndex--;
                tabView.getTab(tabView.currentIndex).setFocus();
            }
        }
    }
    function prePage() {
        if(cmdHistoryArr && cmdHistoryArr.length > 0) {
//            console.log("cmdHistoryArr1 ", cmdHistoryArr.length);
            exeCmd(cmdHistoryArr[cmdHistoryArr.length-1], true, 1);
            cmdHistoryArr.splice(cmdHistoryArr.length-1, 1);
//            console.log("cmdHistoryArr2 ", cmdHistoryArr.length);
        }
    }
    function nextPage() {
        let ctabCmd = curTabCmd[tabView.currentIndex];
        if(cmdHistoryArr.length === 0 || cmdHistoryArr[cmdHistoryArr.length-1] !== ctabCmd) {
            cmdHistoryArr[cmdHistoryArr.length] = ctabCmd;
        } else {
            return;
        }
        //
        let tab = tabView.getTab(tabView.currentIndex);
        let endRow = tab.endRow();
        if(!endRow || endRow.length <= 0) {
            return;
        }
        let arr = ctabCmd.split(" ");
//        console.log(root.curCmd, JSON.stringify(arr));
        if(arr.length > 1) {
            let k = arr[0];
            let pageSize = arr[arr.length-1];
//            console.log(k, pageSize);
            if(k === "find") {
                var newCmd;
                let keyType = Com.parseKeyType(arr[1]);
                if(keyType === Com.KEY_TYPE_HASH) {
                    newCmd = replaceFindCmdNextPageParam(ctabCmd, endRow, pageSize);
                    if(newCmd === '1') {
                        newCmd = addFindCmdCond(ctabCmd, endRow, pageSize);
                    }
                } else if(keyType === Com.KEY_TYPE_ZSET) {
                    newCmd = "";
                }
                exeCmd(newCmd, true);
            } else {
                let i = Com.indexPageingNoParamCMD(k.substring(1));
                if(i >= 0) {
                    let endK = endRow[Com.PageingNoParamCMDCol[i]];
    //                console.log(Com.PageingNoParamCMDCol[i], endK);
                    let newCmd = k + " " + endK + " - " + pageSize
                    exeCmd(newCmd, true);
                }
            }
//            console.log(JSON.stringify(endRow));
        }
    }

    //find h:pobi:%d(id,name,tags,ct)
    //find h:pobi:%d{id(10000017,)}(id,name,tags,ct)
    function addFindCmdCond(ctabCmd, endRow, pageSize) {
        let i = ctabCmd.indexOf("(");
        if(i < 0) {
            return "";
        }
        let kv = Com.getFirstKV(endRow);
        let paramKey = kv[0];
        let paramVal = kv[1];
        let newCmd = ctabCmd.substring(0, i) + "{" + paramKey + "(" + paramVal + ",)}" + ctabCmd.substring(i);
        return newCmd;
    }
    //find h:pobi:%d{id(10000005,)}(id,name,tags,ct,lst) 10
    function replaceFindCmdNextPageParam(cmd, endRow, pageSize) {
        console.log("replaceFindCmdNextPageParam", cmd, endRow, pageSize);
        let kv = Com.getFirstKV(endRow);
        let paramKey = kv[0];
        let paramVal = kv[1];
        //
        let param = endRow[paramKey];
        let arr = cmd.split(" ");
        if(arr.length > 1) {
            let src = arr[1];
            let i0 = src.indexOf("{");
            if(i0 < 0) {
                return "1";
            }
            let i1 = src.indexOf("}");
            if(i1 < 0) {
                return "1";
            }
            if(i0>=i1) {
                return "";
            }
            let cond = src.substring(i0+1,i1);
            //
            let paramI0 = cond.indexOf("(");
            if(paramI0 < 0) {
                paramI0 = cond.indexOf("[");
            }
            if(paramI0 < 0) {
                return "";
            }
            let paramI1 = cond.indexOf(")");
            if(paramI1 < 0) {
                paramI1 = cond.indexOf("]");
            }
            if(paramI1 < 0) {
                return "";
            }
            if(paramI0>=paramI1) {
                return "";
            }
            let condRange = cond.substring(paramI0+1, paramI1);
            let rangeSepIndex = condRange.indexOf(",");
            if(rangeSepIndex < 0) {
                return "";
            }
            //
            let paramIndex0 = i0 + paramI0 + 1;
            let paramIndex1 = i0 + paramI0 + 1 + rangeSepIndex + 1;
            let newSrc = src.substring(0, paramIndex0+1) + param + src.substring(paramIndex1);
            let newCmd = arr[0] + " " + newSrc + " " + pageSize;
//            console.log(">>>>>>>>>", src.substring(paramIndex0+1,paramIndex1), param, newSrc);
//            console.log(">>>>>>>>>", newCmd);
            return newCmd;
        }
    }
    function getNodeById(id) {
        let count = treemodel.rowCount();
        for(let i = 0; i < count; i++) {
            let n = treemodel.getNodeByIndex(treemodel.index(i, 0));
            if(n && n.id === id) {
                return n;
            }
        }
        return null;
    }
    function getQuery1Text() {
        let tab = tabView.getTab(0);
        return tab.getText();
    }
    function setQuery1Text(v) {
        let tab = tabView.getTab(0);
        return tab.setText(v);
    }
    function clickTableCell(row,column,value) {
        console.log(row, column, value);
        let curTabCmd = root.curTabCmd[tabView.currentIndex];
        let arr = curTabCmd.split(" ");
        let pageSize = 0;
        if(arr.length > 1) {
            pageSize = arr[arr.length-1];
        }
        if(arr.length > 1) {
            let k = arr[0];
            if(k === "/hlist") {
                exeSubCmd("/hgetall " + value);
            } else if(k === "/zlist") {
                exeSubCmd("/zscan " + value + " - - - " + pageSize);
            } else if(k === "find") {
                let srcType = Com.parseKeyType(arr[1]);
                if(srcType === Com.KEY_TYPE_ZSET) {
                    if(column === 0) {
                        exeSubCmd("/zscan " + value + " - - - " + pageSize);
                    }
                }
            }
        }
    }
    function copy(txt) {
        $app.copy(txt);
    }
    function preSubPage() {
        if(subCmdHistoryArr && subCmdHistoryArr.length > 0) {
            exeSubCmd(subCmdHistoryArr[subCmdHistoryArr.length-1], true);
            subCmdHistoryArr.splice(subCmdHistoryArr.length-1, 1);
        }
    }
    function nextSubPage() {
        let ctscmd = curTabSubCmd[tabView.currentIndex];
        if(subCmdHistoryArr.length === 0 || (subCmdHistoryArr[subCmdHistoryArr.length-1] !== ctscmd)) {
            subCmdHistoryArr[subCmdHistoryArr.length] = ctscmd;
        }
        //
        let curTSCmd = curTabSubCmd[tabView.currentIndex];
        let arr = curTSCmd.split(" ");
        let pageSize = 0;
        if(arr.length > 1) {
            pageSize = arr[arr.length-1];
        }
        let tab = tabView.getTab(tabView.currentIndex);
        let endSubRow = tab.endSubRow();
        if(!endSubRow) {
            return;
        }
        if(arr.length > 1) {
            let k = arr[0];
            if(k === "/zscan") {
                let endK = endSubRow['key'];
                if(endK) {
                    let zsetkey = arr[1];
                    exeSubCmd("/zscan " + zsetkey + " " + endK + " - - " + pageSize);
                }
            }
        }
    }
    function submitCell(row, column, value, newValue, headers, rows) {
        console.log(row, column, value, newValue, JSON.stringify(headers), JSON.stringify(rows));
        let ctabCmd = curTabCmd[tabView.currentIndex];
        submitCell0(row, column, value, newValue, headers, rows, ctabCmd);
    }
    function submitCell0(row, column, value, newValue, headers, rows, ctabCmd) {
        let arr = ctabCmd.split(" ");
        if(arr.length > 1) {
            let k = arr[0];
            if(k === "find") {
                let srcType = Com.parseKeyType(arr[1]);
                if(srcType === Com.KEY_TYPE_HASH) {
                    let hashkey = rows["___"];
                    let field = headers[column];
                    upHashField(hashkey, field, newValue);
                }
            } else if(k === "/hgetall") {
                if(column < 1) {
                    return;
                }
                let hashkey = arr[1];
                let field = rows[headers[0]];
                upHashField(hashkey, field, newValue);
            } else if(k === "/hget") {
                if(arr.length < 2) {
                    return;
                }
                let hashkey = arr[1];
                let field = arr[2];
                upHashField(hashkey, field, newValue);
            } else if(k === "/zscan") {

            }
        }
    }
    function upHashField(hashkey, field, newValue) {
        if(hashkey && field) {
            newValue = Com.quote(newValue);
            let cmd = "/hset " + hashkey + " " + field + " " + newValue;
            console.log(cmd);
            $app.exe(cmd, fu(function(r) {
                let d = JSON.parse(r);
                if(d.err) {
                    alert(d.err);
                }
            }));
        }
    }

    function getNodeText(ind, val) {
        if(ind.parent && ind.parent.row < 0) {
            let n = treemodel.getNodeByIndex(ind);
            if(n && n.alias) {
                return n.alias;
            }
        }
        return val;
    }
    function isNodeConnected(ind) {
        let n = treemodel.getNodeByIndex(ind);
        return n && n.connSt === 1;
    }
    function isNodeEditing(ind) {
        let n = treemodel.getNodeByIndex(ind);
        return n && n.st === 1;
    }
    function getCurPage() {
        return page;
    }
    function getCurResultSelectedRows() {
        let tab = tabView.getTab(tabView.currentIndex);
        return tab.getCurResultSelectedRows();
    }
    function deleteCurResultSelectedRows() {
        let tab = tabView.getTab(tabView.currentIndex);
        return tab.deleteCurResultSelectedRows();
    }
    function deleteRows(rows) {
        let ctabCmd = curTabCmd[tabView.currentIndex];
        let arr = ctabCmd.split(" ");
        if(arr.length > 1) {
            let k = arr[0];
            if(k === "find") {
                let srcType = Com.parseKeyType(arr[1]);
                if(srcType === Com.KEY_TYPE_HASH) {
                    for(let i = 0; i < rows.length; i++) {
                        let hashkey = rows[i]["___"];
                        if(hashkey) {
                            let cmd = "/hclear " + hashkey;
                            deleteRows0(cmd, function(){
                                deleteCurResultSelectedRows();
                            });
                        }
                    }
                }
            }
        }
    }
    function deleteRows0(cmd, cb) {
        console.log(cmd);
        $app.exe(cmd, fu(function(r) {
            let d = JSON.parse(r);
            if(d.err) {
                alert(d.err);
            } else {
                cb();
            }
        }));
    }
}
