#!/usr/bin/env bash
set -euo pipefail

lua_config=false
if [[ $(hyprctl repl 'return type(hl)' 2>/dev/null) == table ]]; then
    lua_config=true
    animations=$(hyprctl repl 'return hl.get_config("animations.enabled")')
else
    animations=$(hyprctl getoption animations:enabled | awk 'NR == 1 { print $2 }')
fi

# Preserve the existing Waybar performance toggle.
style="$HOME/.config/waybar/style.css"
if [[ -f $style ]]; then
    sed -i 's/\/\* \(.*animation:.*\) \*\//\1/g' "$style"
    sed -i 's/\/\* \(.*transition:.*\) \*\//\1/g' "$style"
    if [[ $animations == true || $animations == 1 ]]; then
        sed -i 's/^\(.*animation:.*\)$/\/\* \1 \*\//g' "$style"
        sed -i 's/^\(.*transition:.*\)$/\/\* \1 \*\//g' "$style"
    fi
fi
killall waybar || true
waybar >/dev/null 2>&1 &

if [[ $animations == true || $animations == 1 ]]; then
    if $lua_config; then
        hyprctl eval 'hl.config({ animations = { enabled = false }, decoration = { shadow = { enabled = false }, blur = { enabled = false }, rounding = 0 }, general = { gaps_in = 0, gaps_out = 0, border_size = 1 } })'
    else
        hyprctl --batch 'keyword animations:enabled 0; keyword decoration:shadow:enabled 0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword decoration:rounding 0'
    fi
else
    hyprctl reload
fi
