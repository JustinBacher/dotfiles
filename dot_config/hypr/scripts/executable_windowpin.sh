#!/usr/bin/env bash
set -euo pipefail

if [[ $(hyprctl repl 'return type(hl)' 2>/dev/null) == table ]]; then
    # Pinning requires a floating window. Unpinning restores the existing
    # helper's behavior of tiling the window again.
    hyprctl eval 'local window = hl.get_active_window(); if window then local was_pinned = window.pinned; if not window.floating and not was_pinned then hl.dispatch(hl.dsp.window.float({ action = "set" })) end; hl.dispatch(hl.dsp.window.pin({ action = "toggle" })); if was_pinned then hl.dispatch(hl.dsp.window.float({ action = "unset" })) end end'
else
    floating=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .floating')
    pinned=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .pinned')
    if [[ $floating == false && $pinned == false ]]; then
        hyprctl dispatch togglefloating active
    fi
    hyprctl dispatch pin active
    if [[ $pinned == true ]]; then
        hyprctl dispatch togglefloating active
    fi
fi
