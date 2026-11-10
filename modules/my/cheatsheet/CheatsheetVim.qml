pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import Quickshell
import Quickshell.Io

// Vim cheatsheet page. Data: ~/.config/hypr/custom/scripts/cheatsheet-vim/vim-cheatsheet.json
// Installed by ~/.config/hypr/custom/scripts/cheatsheet-vim/apply.sh (end-4 dots updates overwrite this dir)
Item {
    id: root
    property var categories: []
    implicitWidth: QsWindow?.window?.screen.width * 0.7 ?? 0
    implicitHeight: QsWindow?.window?.screen.height * 0.7 ?? 0

    FileView {
        id: dataFile
        path: `${Directories.config}/hypr/custom/scripts/cheatsheet-vim/vim-cheatsheet.json`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            try {
                root.categories = JSON.parse(dataFile.text());
            } catch (e) {
                console.error("[CheatsheetVim] Error parsing vim-cheatsheet.json:", e);
            }
        }
    }

    StyledFlickable {
        id: flickable
        clip: true
        anchors.fill: parent
        anchors.margins: Appearance.rounding.small
        contentHeight: height
        contentWidth: flow.implicitWidth
        Flow {
            id: flow
            height: flickable.height
            flow: Flow.TopToBottom
            spacing: 10
            Repeater {
                model: root.categories
                delegate: CheatsheetVimCategory {
                    required property var modelData
                    categoryName: modelData.category
                    binds: modelData.binds
                }
            }
        }
    }

    ScrollEdgeFade {
        target: flickable
        vertical: false
        color: Appearance.colors.colLayer0Base
    }
}
