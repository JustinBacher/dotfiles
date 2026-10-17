#!/usr/bin/env bash
set -euo pipefail

cargo=${CARGO_BIN:-cargo}
crates=(
    ast-grep
    cargo-chef
    cargo-make
    cargo-sort
    cargo-update
    sqlx-cli
    unused-pub
)

for crate in "${crates[@]}"; do
    "$cargo" install "$crate"
done
