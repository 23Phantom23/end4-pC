pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.widgets
import QtQuick

// keys format: space-separated tokens, each token is one keycap; "/" between tokens means "or"
Column {
    id: root
    required property string categoryName
    required property var binds
    property int maxBindWidth: 0
    property real columnSpacing: 40
    property real titleSpacing: 7

    spacing: titleSpacing

    StyledText {
        text: root.categoryName
        font.pixelSize: Appearance.font.pixelSize.title
    }

    Column {
        spacing: 4
        Repeater {
            model: root.binds
            delegate: BindLine {
                required property var modelData
                keys: modelData.keys
                desc: modelData.desc
            }
        }
    }

    component BindLine: Row {
        id: bindLine
        required property string keys
        required property string desc
        spacing: 16

        Row {
            Component.onCompleted: root.maxBindWidth = Math.max(root.maxBindWidth, implicitWidth)
            width: root.maxBindWidth
            spacing: 4
            Repeater {
                model: bindLine.keys.split(" ")
                delegate: Item {
                    id: token
                    required property string modelData
                    readonly property bool isSeparator: modelData === "/"
                    anchors.verticalCenter: parent?.verticalCenter
                    implicitWidth: isSeparator ? orText.implicitWidth : keyCap.implicitWidth
                    implicitHeight: isSeparator ? orText.implicitHeight : keyCap.implicitHeight
                    StyledText {
                        id: orText
                        visible: token.isSeparator
                        anchors.centerIn: parent
                        text: "/"
                    }
                    KeyboardKey {
                        id: keyCap
                        visible: !token.isSeparator
                        key: token.modelData
                        pixelSize: CheatsheetSettings.fontSize.key
                        color: Appearance.colors.colOnLayer0
                    }
                }
            }
        }
        Item {
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: commentText.implicitWidth + root.columnSpacing
            implicitHeight: commentText.implicitHeight
            StyledText {
                id: commentText
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.pixelSize: CheatsheetSettings.fontSize.comment || Appearance.font.pixelSize.smaller
                text: bindLine.desc
            }
        }
    }
}
