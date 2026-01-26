function ud
    sudo -v

    function colored
        set color $argv[1]
        set label $argv[2..-1]

        echo (set_color $color) $label (set_color normal)
    end

    function safe
        # First argument is the description
        set description $argv[1]

        # Everything else is the command
        set cmd $argv[2..-1]

        # Skip if empty
        if test -z "$cmd[1]"
            return
        end

        set cmd_str "$cmd"

        # Determine which command to check
        if test $cmd[1] = sudo -a (count $cmd) -gt 1
            # If first word is sudo, check second word
            set check_cmd $cmd[2]
        else
            set check_cmd $cmd[1]
        end

        # Skip if the command doesn't exist
        type -q $check_cmd; or return

        echo Running $cmd_str
        fish -c "$cmd_str"
        set exit_code $status

        # Result
        if test $exit_code -eq 0
            colored green ✔ $description done
        else
            colored red ❌ $description failed
            return $exit_code
        end
    end

    function detect_system_updater
        # Arch Linux / AUR helpers
        if type -q paru
            set -l updater "paru -Syu"
        else if type -q yay
            set -l updater "yay -Syu"
        else if type -q pacman
            set -l updater "sudo pacman -Syu"

            # Debian / Ubuntu
        else if type -q aptitude
            set -l updater "sudo aptitude update && sudo aptitude safe-upgrade -y"
        else if type -q apt
            set -l updater "sudo apt update && sudo apt upgrade -y"

            # Fedora
        else if type -q dnf
            set -l updater "sudo dnf upgrade -y"

            # openSUSE
        else if type -q zypper
            set -l updater "sudo zypper refresh && sudo zypper update -y"

        else
            echo "No known package manager found!"
            return 1
        end

        echo $updater
    end

    # System packages
    safe "system packages" paru -Syu
    safe "Homebrew packages" brew update && brew upgrade

    # Development tools
    safe "Rust toolchains" rustup update
    safe "NPM packages" sudo npm update -g
    safe "Conda packages" conda update --all -y
    safe "Mamba packages" mamba update --all -y

    # Cargo
    if type -q cargo-update
        safe "Cargo binaries" cargo install-update -a
    else
        gum spin \
            --spinner dot \
            --title "Installing cargo-update" \
            -- cargo install cargo-update
    end

    # Other
    safe "Yazi plugins" ya pkg upgrade
    safe "Hyprland plugins" hyprctl plugin update

    # Containerized apps
    safe "Flatpak apps" flatpak update -y
    safe "Snap packages" sudo snap refresh

    # Shell plugins
    safe "Fisher plugins" fisher update
    safe "Oh My Fish plugins" omf update
    safe "Oh My Zsh" upgrade_oh_my_zsh
    # safe "Zsh(Antigen) plugins" zsh -ic 'antigen update'
    # safe "Zinit plugins" zsh -ic 'zinit self-update; zinit update'

    colored green "All updates complete ✅"
end
