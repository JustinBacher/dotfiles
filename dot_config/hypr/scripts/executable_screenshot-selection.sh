#!/usr/bin/env bash
set -euo pipefail

case "${1:-area}" in
    area)
        geometry=$(slurp < /dev/null) || exit 0
        ;;
    window)
        boxes=$(hyprctl clients -j | jq -r --argjson monitors "$(hyprctl monitors -j)" '
            ($monitors | map(.activeWorkspace.id, .specialWorkspace.id) | unique) as $visible
            | .[]
            | select(.mapped and (.hidden | not))
            | select(.workspace.id as $id | $visible | index($id))
            | select(.size[0] > 0 and .size[1] > 0)
            | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
        ')
        [[ -n "$boxes" ]] || exit 0
        geometry=$(printf '%s\n' "$boxes" | slurp -r) || exit 0
        ;;
    *)
        printf 'Usage: %s [area|window]\n' "$0" >&2
        exit 2
        ;;
esac

grim -g "$geometry" - | wl-copy --type image/png
