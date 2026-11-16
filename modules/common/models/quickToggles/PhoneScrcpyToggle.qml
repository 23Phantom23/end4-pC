import QtQuick
import Quickshell
import Quickshell.Io
import qs
import qs.services

// my: phone screen via scrcpy (~/.local/bin/phone-scrcpy from my-dots).
// Lit while its scrcpy window is open; click again closes it.
QuickToggleModel {
    id: root
    required property string mode // "mirror" | "dex"
    readonly property string pattern: "--window-title=S26 " + mode + "( |$)"

    name: mode === "dex" ? "DeX" : Translation.tr("Phone mirror")
    tooltipText: mode === "dex" ? Translation.tr("Phone DeX (USB)") : Translation.tr("Phone screen mirror (USB)")
    icon: mode === "dex" ? "desktop_windows" : "mobile_screen_share"
    hasStatusText: false
    toggled: false

    mainAction: () => {
        if (root.toggled) {
            Quickshell.execDetached(["pkill", "-f", "--", root.pattern]);
            root.toggled = false;
        } else {
            GlobalStates.sidebarRightOpen = false;
            Quickshell.execDetached(["bash", "-c", 'exec "$HOME/.local/bin/phone-scrcpy" "$1"', "_", root.mode]);
            root.toggled = true;
        }
    }

    Process {
        id: check
        command: ["pgrep", "-f", "--", root.pattern]
        onExited: (exitCode, exitStatus) => { root.toggled = exitCode === 0; }
    }
    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: check.running = true
    }
}
