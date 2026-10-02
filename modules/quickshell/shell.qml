pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

ShellRoot {
    Variants {
        model: Quickshell.screens

        // qmllint disable uncreatable-type
        PanelWindow {
            id: bar

            required property var modelData
            screen: modelData
            property var monitor: Hyprland.monitorFor(modelData)
            readonly property string barFont: Qt.fontFamilies().includes("Berkeley Mono") ? "Berkeley Mono" : "SauceCodePro Nerd Font"

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 32
            color: "transparent"

            WlrLayershell.namespace: "quickshell:bar"

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.33)
            }

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Repeater {
                    model: Hyprland.workspaces

                    Rectangle {
                        id: ws

                        required property var modelData
                        visible: modelData.monitor === bar.monitor
                        implicitWidth: 22
                        implicitHeight: 22
                        color: modelData.focused ? "#554cb9b9" : "transparent"
                        border.color: "white"
                        border.width: modelData.active && !modelData.focused ? 1 : 0

                        Text {
                            anchors.centerIn: parent
                            text: ws.modelData.name
                            color: "white"
                            font.family: bar.barFont
                            font.pixelSize: 16
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: ws.modelData.activate()
                        }
                    }
                }
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
                font.family: bar.barFont
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
