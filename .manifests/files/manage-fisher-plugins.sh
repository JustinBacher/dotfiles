#!/usr/bin/env bash
set -euo pipefail

config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
plugin_file="$config_home/fish/fish_plugins"

install -Dm644 "$(dirname "$0")/fish_plugins.txt" "$plugin_file"
"${FISH_BIN:-fish}" -c 'fisher update'
