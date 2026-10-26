# dotfiles

This repo configures my machines. Two tools split the work:

- **chezmoi** manages files, including Mise's global configuration under `~/.config/mise`.
- **mise** manages packages, development tools, and one-time setup.

This is only set up for Arch machines.

## Installation

1. Install chezmoi and apply the files:

   ```shell
   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply JustinBacher
   ```

2. Install Mise from the Arch repository, then bootstrap the machine. Unlock Keeper first, because the GitHub SSH step reads its secrets from it:

   ```shell
   sudo pacman -S --needed mise
   mise bootstrap
   ```

Before the package pass, the `pre-packages` hook ensures git, base-devel, rustup, and Paru are available. It installs Paru from a configured Pacman repository when possible and otherwise builds it from the AUR. Mise then applies the `pacman:` and `aur:` package entries, installs the global `[tools]`, and runs the remaining `system`, `github`, and `wallpapers` tasks.

## User-level tools

Mise's global `[tools]` installs stable Rust, the Cargo CLIs, the pinned ACP
adapters, and the unpinned npm CLIs. `system:fisher` reconciles Fisher against
the declaratively managed `~/.config/fish/fish_plugins`.

## Hyprland plugins

`system:hyprpm` uses Hyprland's plugin manager to install, update, and enable:

- [Hyprglass](https://github.com/hyprnux/hyprglass)
- [dynamic-cursors](https://github.com/VirtCode/hypr-dynamic-cursors)
- [hyprchromakey](https://github.com/TheWoomy27/hyprchromakey)

The managed `hypr/plugins.lua` configures these plugins. Hyprland runs
`hyprpm reload` at startup to load the enabled plugins.

Spotify keeps its Spicetify theme unchanged: a Spotify-only chromakey profile
makes black (`#000000`) chrome partially transparent, and Hyprglass uses the
`transparent_blur` preset behind it. Near-black (`#121212`) panels and gray
(`#242424`) cards stay opaque. Whole-window opacity stays at 100%. Keyed
black pixels retain 70% opacity, but matching pixels in artwork are also
affected. Theme changes may require retuning the key in `hypr/plugins.lua`.

Steam's main window uses the same `transparent_blur` preset with a separate
chromakey profile for Material's Dark/Blue background (`#111318`) and
sidebar/app bars (`#1d2024`). Keyed pixels retain 70% opacity; text and
nonmatching artwork remain opaque. The profile only matches the `Steam`
window title and Steam client classes, not games, Friends & Chat, or layer
surfaces. Material's theme files and whole-window opacity are unchanged.
Changing Material's appearance or source color may require retuning these keys.

Disable chroma keying for the current session with:
```sh
hyprctl eval 'hl.plugin.hyprchromakey.set_all("off")'
```
Use `set_all("config")` to return to the configured behavior.

## Tmux session persistence

TPM loads `tmux-resurrect` and `tmux-continuum` from the managed tmux config.
On a new machine, install the declared plugins with **Ctrl-Space, Shift-I**.

- Continuum saves the workspace every 15 minutes while the tmux status line runs.
- After reboot, start `tmux` to restore the last snapshot automatically.
- Save immediately before reboot with **Ctrl-Space, Ctrl-S**.
- Restore manually with **Ctrl-Space, Ctrl-R**.

Restoration recreates sessions, windows, panes, layouts, and working directories.
Selected supported programs can be relaunched; running process memory and jobs
do not survive reboot. This does not start tmux automatically at login.
Keep Continuum last in the plugin list so themes do not overwrite its autosave hook.

## Notes

- `mise bootstrap` invokes root-required package, file, and NVIDIA steps through `sudo`. Run it as your user, not as root.
- The NVIDIA step edits `/etc/mkinitcpio.conf` and rebuilds the initramfs on NVIDIA machines.
- A `gitleaks` pre-commit hook blocks commits that stage secrets. Enable it once per clone with `git config core.hooksPath .githooks`. Bypass a false positive with `git commit --no-verify`.
- Secrets for templates (for example the Noctalia API keys) come from `pass`. Add them with `pass insert noctalia/openrouter`, `noctalia/zen`, and `noctalia/wallhaven`. Missing entries render as empty strings.
- `dot_config/mise/packages.toml` is the package list. Edit its `[bootstrap.packages]` table by hand. `pacman -Qqe` shows what is installed but not listed.
