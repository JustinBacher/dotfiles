# dotfiles

This repo configures my machines. Two tools split the work:

- **chezmoi** manages files: dotfiles and config under `~`.
- **comtrya** manages packages and one-time setup. Its manifests live in `.manifests/`.

This is only set up for Arch machines.

## Installation

1. Install chezmoi and apply the files:

   ```shell
   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply JustinBacher
   ```

2. Install comtrya (AUR `comtrya`), then run the packages and setup. Unlock Keeper first, because the GitHub SSH step reads its secrets from it:

   ```shell
   cd "$(chezmoi source-path)/.manifests" && comtrya apply
   ```

Steps run in this order: `linux.bootstrap` (git, base-devel, rustup, paru), `linux.packages` (`packages.yaml`, plus `ollama-cuda` for NVIDIA display hardware or `ollama` otherwise), then `linux.system`, `linux.ai-agents`, `linux.github`, and `linux.wallpapers`.

## User-level tools

`linux.ai-agents` installs pinned ACP adapters and the unpinned global npm CLIs
listed in its manifest. `linux.system` installs the unpinned Cargo tools in
`files/install-cargo-tools.sh` and reconciles Fisher exactly to
`files/fish_plugins.txt`.

## Hyprland plugins

`linux.system` uses Hyprland's plugin manager to install, update, and enable:

- [Hyprglass](https://github.com/hyprnux/hyprglass)
- [dynamic-cursors](https://github.com/VirtCode/hypr-dynamic-cursors)

The managed `hypr/plugins.lua` configures both plugins. Hyprland runs
`hyprpm reload` at startup to load the enabled plugins.

## Notes

- `comtrya apply` runs root steps through `sudo`. Run it as your user, not as root.
- The NVIDIA step edits `/etc/mkinitcpio.conf` and rebuilds the initramfs on NVIDIA machines.
- A `gitleaks` pre-commit hook blocks commits that stage secrets. Enable it once per clone with `git config core.hooksPath .githooks`. Bypass a false positive with `git commit --no-verify`.
- Secrets for templates (for example the Noctalia API keys) come from `pass`. Add them with `pass insert noctalia/openrouter`, `noctalia/zen`, and `noctalia/wallhaven`. Missing entries render as empty strings.
- `packages.yaml` is the package list. Edit it by hand. `pacman -Qqe` shows what is installed but not listed.
- `linux.ai-agents` installs pinned ACP adapters for avante.nvim.
