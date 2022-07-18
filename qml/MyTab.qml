import QtQuick 2.15
import QtQuick.Controls 1.4
import "com"
import "com/com.js" as Com

Tab {
    title: "Query1"
    Rectangle {
        id: root
        color: "#292929"
        TextArea {
            id: textArea
            width: parent.width
            backgroundVisible: false
            font.pointSize: 14
            height: 200
            textColor: "white"
            Keys.onPressed: {
                onQueryEditorKeysPressed(textArea.text, event, textArea.cursorPosition, textArea.selectedText);
            }
        }
        TabView {
            id: tabView
            y: textArea.height
            width: parent.width
            height: parent.height - textArea.height
            style: MyTabViewStyle {
                closeBtnVisable: false
            }
            Tab {
                id: tab
                title: "Result"
                MyResult {}
                function fill(d, isPaging, cmd) {
                    item.fill(d, isPaging, cmd);
                }
                function fillSubData(d,cmd) {
                    item.fillSubData(d,cmd);
                }
                function endRow() {
                    return item.endRow();
                }
                function endSubRow() {
                    return item.endSubRow();
                }
                function getCurResultSelectedRows() {
                    return item.getCurResultSelectedRows();
                }
                function deleteCurResultSelectedRows() {
                    return item.deleteCurResultSelectedRows();
                }
            }
        }
        function getSelectedText() {
            return textArea.selectedText;
        }
        function setCurrentNodeToQueryEditor(name) {
            textArea.text = textArea.text.trim();
            if(textArea.text) {
                let i = textArea.text.indexOf(name);
                if(i < 0) {
                    textArea.text += "\n"+name;
                    textArea.select(textArea.text.length-name.length, textArea.text.length);
                } else {
                    textArea.select(i, i+name.length);
                }
            } else {
                textArea.text += name;
                textArea.select(textArea.text.length-name.length, textArea.text.length);
            }
        }
        function fill(d, isPaging, cmd) {
            tabView.getTab(0).fill(d, isPaging, cmd);
        }
        function fillSubData(d, cmd){
            tabView.getTab(0).fillSubData(d,cmd);
        }
        function endRow() {
            return tabView.getTab(0).endRow();
        }
        function endSubRow() {
            return tabView.getTab(0).endSubRow();
        }
        function getText() {
            return textArea.text;
        }
        function setText(v) {
            return textArea.text = v;
        }
        function setFocus() {
            textArea.forceActiveFocus();
        }
        function getCurResultSelectedRows() {
            return tabView.getTab(0).getCurResultSelectedRows();
        }
        function deleteCurResultSelectedRows() {
            return tabView.getTab(0).deleteCurResultSelectedRows();
        }
        MouseArea {
            y: textArea.height - 5
            width: parent.width
            height: 10
            hoverEnabled: true
            property int startY:0
            onPressed:{
                startY = mouse.y
            }
            onReleased: {
                startY = 0;
    //                $app.set($app.ENV_K_LAST_BOOK_LEFT_WIDTH, Math.floor(work_list.width));
            }
            onPositionChanged:{
                if(startY > 0) {
                    let top = mouse.y < startY;
                    if(top){
                        let delta = startY - mouse.y;
                        textArea.height = Com.max(100,textArea.height - delta);
                    } else {
                        let delta = mouse.y - startY;
                        textArea.height = Com.min(root.height/3*2,textArea.height + delta);
                    }
    //                    $app.setUIVal(1, note_list.width);
                }
            }
            onEntered: {
                cursorShape = Qt.SizeVerCursor
            }
            onExited: {
                cursorShape = Qt.ArrowCursor
            }
        }
    }
    function getSelectedText() {
        return item.getSelectedText();
    }
    function setCurrentNodeToQueryEditor(name) {
        item.setCurrentNodeToQueryEditor(name);
    }
    function fill(d, isPaging, cmd) {
        item.fill(d, isPaging, cmd);
    }
    function fillSubData(d, cmd) {
        item.fillSubData(d, cmd);
    }
    function endRow() {
        return item.endRow();
    }
    function endSubRow() {
        return item.endSubRow();
    }
    function getText() {
        return item.getText();
    }
    function setText(v) {
        return item.setText(v);
    }
    function setFocus() {
        item.setFocus();
    }
    function getCurResultSelectedRows() {
        return item.getCurResultSelectedRows();
    }
    function deleteCurResultSelectedRows() {
        return item.deleteCurResultSelectedRows();
    }
}
