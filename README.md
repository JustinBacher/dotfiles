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

   Steps run in this order: `linux.bootstrap` (git, base-devel, rustup, paru), `linux.packages` (`packages.yaml`), then `linux.system`, `linux.ai-agents`, `linux.github`, and `linux.wallpapers`.

## Hyprland plugins

Install and enable [Hyprglass](https://github.com/hyprnux/hyprglass) with Hyprland's plugin manager:

```shell
hyprpm add https://github.com/hyprnux/hyprglass
hyprpm enable hyprglass
```

The managed `hypr/plugins.lua` configures Hyprglass after it loads, using its default glass preset and dark theme. Hyprland runs `hyprpm reload` at startup to load enabled plugins.

## Notes

- `comtrya apply` runs root steps through `sudo`. Run it as your user, not as root.
- The NVIDIA step edits `/etc/mkinitcpio.conf` and rebuilds the initramfs on NVIDIA machines.
- `packages.yaml` is the package list. Edit it by hand. `pacman -Qqe` shows what is installed but not listed.
- `linux.ai-agents` installs pinned ACP adapters for avante.nvim.
