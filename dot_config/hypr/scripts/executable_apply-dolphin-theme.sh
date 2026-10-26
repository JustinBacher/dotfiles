#!/usr/bin/env bash
set -euo pipefail

stylesheet_path="${XDG_CONFIG_HOME:-$HOME/.config}/dolphin/noctalia-glass.qss"
[[ -r "$stylesheet_path" ]] || exit 0

stylesheet=$(<"$stylesheet_path")
while IFS= read -r service; do
    while IFS= read -r object; do
        qdbus6 "$service" "$object" org.qtproject.Qt.QWidget.setStyleSheet "$stylesheet"
    done < <(qdbus6 "$service" | grep '^/dolphin/Dolphin_[0-9][0-9]*$' || true)
done < <(qdbus6 | sed -n 's/^ \(org\.kde\.dolphin-[0-9][0-9]*\)$/\1/p')
