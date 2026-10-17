#!/usr/bin/env bash
set -euo pipefail

hyprpm=${HYPRPM_BIN:-hyprpm}
state="$("$hyprpm" list)"

plugin_enabled() {
    local plugin=$1
    local line
    local found=false

    while IFS= read -r line; do
        if [[ $line == *"Plugin $plugin"* ]]; then
            found=true
            continue
        fi

        if [[ $found == true && $line == *"enabled: true"* ]]; then
            return 0
        fi

        if [[ $found == true && ( $line == *"Plugin "* || $line == *"Repository "* ) ]]; then
            return 1
        fi
    done <<<"$state"

    return 1
}

ensure_plugin() {
    local plugin=$1
    local repository=$2

    if [[ $state != *"Plugin $plugin"* ]]; then
        "$hyprpm" add "$repository"
        state="$("$hyprpm" list)"
    fi

    if ! plugin_enabled "$plugin"; then
        "$hyprpm" enable "$plugin"
        state="$("$hyprpm" list)"
    fi
}

ensure_plugin hyprglass https://github.com/hyprnux/hyprglass
ensure_plugin dynamic-cursors https://github.com/VirtCode/hypr-dynamic-cursors

"$hyprpm" update
