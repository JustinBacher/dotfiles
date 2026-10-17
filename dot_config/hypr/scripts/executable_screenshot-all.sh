#!/usr/bin/env bash
set -euo pipefail

directory="$(xdg-user-dir PICTURES)/Screenshots"
mkdir -p "$directory"
capture="$directory/Screenshot-$(date +%Y-%m-%d_%H-%M-%S-%N).png"
grim "$capture"
wl-copy --type image/png < "$capture"
notify-send -a Caelestia -i "$capture" "Screenshot saved" "Saved to $capture and copied to clipboard"
