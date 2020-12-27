import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import Qt.labs.platform 1.0 as Platform


Window {
    id: window
    width: 200
    height: 50
    minimumWidth: (height * 4 > 200) ? height * 4 : 200
    minimumHeight: 50
    visible: true
    color: "#000000"
    title: "SpellSplit"

    property string timerState: "inactive"
    property date timerStart: new Date()
    property date timerEnd: new Date()

    onTimerStateChanged: {
        switch (timerState) {
            case "inactive": timerText.color = "#c0c0c0"; break;
            case "active": timerText.color = "#a0a0ff"; break;
            case "finished": timerText.color = "#00ee00"; break;
        }
    }

    Text {
        id: timerText
        text: "0:00:00.00"
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: window.height / 1.5
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#c0c0c0"

        Timer {
            interval: 10
            running: true
            repeat: true

            onTriggered: {
                if (timerState === "inactive") {
                    parent.text = "0:00:00.00"
                }

                if (timerState === "active") {
                    parent.text = printDuration(timerStart, new Date())
                }

                if (timerState === "finished") {
                    parent.text = printDuration(timerStart, timerEnd)
                }
            }

            function printDuration(begin, end) {
                var diff = end.valueOf() - begin.valueOf()
                return "%1:%2:%3.%4"
                    .arg(Math.floor(diff / (1000 * 60 * 60))) // hours
                    .arg(pad(Math.floor(diff / (1000 * 60) % 60))) // minutes
                    .arg(pad(Math.floor(diff / 1000 % 60))) // seconds
                    .arg(pad(Math.floor(diff % 1000 / 10))) // msec
            }

            function pad(n) {
                var num = "" + n
                return num.padStart(2, '0')
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton | Qt.LeftButton
        onClicked: {
            if (mouse.button === Qt.RightButton) {
                menu.open()
            }

            if (mouse.button === Qt.LeftButton) {
                if (timerState === "inactive") {
                    timerState = "active"
                    timerStart = new Date()
                    return
                }

                if (timerState === "active") {
                    timerState = "finished"
                    timerEnd = new Date()
                    return
                }

                if (timerState === "finished") {
                    timerState = "inactive"
                    return
                }
            }
        }
    }

    Platform.Menu {
        id: menu

        Platform.MenuItem {
            text: qsTr("Quit")
            onTriggered: window.close()
        }
    }
}
