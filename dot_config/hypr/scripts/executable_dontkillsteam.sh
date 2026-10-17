#!/usr/bin/env bash
set -euo pipefail

if [[ $(hyprctl activewindow -j | jq -r '.class') == Steam ]]; then
    xdotool windowunmap "$(xdotool getactivewindow)"
elif [[ $(hyprctl repl 'return type(hl)' 2>/dev/null) == table ]]; then
    hyprctl dispatch 'hl.dsp.window.close()'
else
    hyprctl dispatch killactive ''
fi
