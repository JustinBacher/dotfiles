#!/usr/bin/env bash
set -euo pipefail

# Lua passes the configured terminal explicitly. Keep manual/legacy invocation.
terminal=${1:-}
if [[ -z $terminal ]]; then
    # Match the legacy literal $term assignment.
    # shellcheck disable=SC2016
    terminal=$(sed -n 's/^\$term[[:space:]]*=[[:space:]]*//p' "${XDG_CONFIG_HOME:-$HOME/.config}/hypr/keybindings.conf")
    terminal=${terminal:-ghostty}
fi
for monitor in htop btop top; do
    if command -v "$monitor" >/dev/null 2>&1; then
        exec "$terminal" -e "$monitor"
    fi
done
