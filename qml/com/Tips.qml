import QtQuick 2.15
import QtQuick.Controls 2.14

Popup {
    id: root
    width: dp(400)
    height: dp(200)
    x: parent.width/2-width/2
    y: parent.height/2-height/2
    focus: true
    clip: true
    topInset: 0
    leftInset: 0
    bottomInset: 0
    rightInset: 0
    padding: 0

    property var cb: null
    property bool autoclose: true

    Rectangle {
        color:"black"
        anchors.fill: parent
        Text {
            id:text
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color:"white"
            width: parent.width
            font.pointSize: dp(16)
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignHCenter
        }
    }
    Timer {
        id: timer
        interval: 3000
        onTriggered: {
            if(autoclose) {
                clo();
            }
        }
    }
    function clo() {
        text.text = '';
        autoclose = true;
        close();
        if(cb && cb instanceof Function) {
            cb();
            cb = null;
        }
    }

    function popup(txt, ac, cb) {
        text.text = txt;
        autoclose = ac?true:false;
        open();
        if(autoclose) {
            timer.start();
        }
        root.cb = cb;
    }
}
