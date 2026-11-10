pragma Singleton
import qs.modules.common
import QtQuick
import Quickshell

// Local settings for the cheatsheet (end4-pC has no `cheatsheet` section in Config.qml).
// Ported from end-4 ii, kept self-contained so upstream end4-pC updates never conflict.
Singleton {
    // 0: 󰖳 | 1: 󰌽 | 2: 󰘳 | 3:  | 4: 󰨡 | 5:  | 6:  | 7: 󰣇 | 8:  | 9:  ...
    property string superKey: ""
    property bool useMacSymbol: false
    property bool splitButtons: false
    property bool useMouseSymbol: false
    property bool useFnSymbol: false
    property QtObject fontSize: QtObject {
        property int key: Appearance.font.pixelSize.smaller
        property int comment: Appearance.font.pixelSize.smaller
    }
}
