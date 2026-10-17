#!/usr/bin/env bash
# One-time: build paru from the AUR so the paru provider in packages.yaml works.
set -euo pipefail

if command -v paru >/dev/null 2>&1; then
    echo "paru already installed"
    exit 0
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

git clone https://aur.archlinux.org/paru.git "$work/paru"
cd "$work/paru"
makepkg -si --noconfirm
