import QtQuick
import Quickshell

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            height: 32
            color: "black"

            Text {
                anchors.centerIn: parent
                color: "white"
                font.family: "Berkeley Mono"
                font.pixelSize: 16
                text: Qt.formatDateTime(clock.date, "ddd MMM dd hh:mm:ss AP")
            }

            SystemClock {
                id: clock
                precision: SystemClock.Seconds
            }
        }
    }
}
