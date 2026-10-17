#!/usr/bin/env bash
set -euo pipefail

exec 9>"${XDG_RUNTIME_DIR:?}/awww-wallpaper-next.lock"
flock -n 9 || exit 0

mapfile -d '' -t wallpapers < <(find "$HOME/Wallpapers" -type f \( \
    -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o \
    -iname '*.gif' -o -iname '*.webp' -o -iname '*.bmp' -o \
    -iname '*.avif' -o -iname '*.tiff' -o -iname '*.tif' \
\) -print0)
if ((${#wallpapers[@]} == 0)); then
    printf 'No supported images found in ~/Wallpapers\n' >&2
    exit 1
fi

state=$(awww query --json)
mapfile -t outputs < <(jq -r '.[""][].name' <<< "$state")
for output in "${outputs[@]}"; do
    current=$(jq -r --arg output "$output" '.[""][] | select(.name == $output) | .displaying.image // ""' <<< "$state")
    index=$((RANDOM % ${#wallpapers[@]}))
    if ((${#wallpapers[@]} > 1)) && [[ ${wallpapers[index]} == "$current" ]]; then
        index=$(((index + 1) % ${#wallpapers[@]}))
    fi
    awww img --outputs "$output" --resize stretch --transition-type grow --transition-duration 1 "${wallpapers[index]}"
done
