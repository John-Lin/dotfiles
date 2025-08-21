#!/usr/bin/env bash

cur_workspace=$(aerospace list-workspaces --focused)

osascript -e '
tell application "Ghostty"
        if it is running then
                activate
                tell application "System Events" to keystroke "n" using {command down}
        else
                activate
        end if
end tell'

aerospace move-node-to-workspace --focus-follows-window "$cur_workspace"
