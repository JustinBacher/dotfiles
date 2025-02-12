#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type keeper >/dev/null 2>&1 && exit

case "$(uname -s)" in
Darwin)
    # I wish there was a brew manifest for Keeper Commander
    sudo curl -o /tmp/keeper.pkg https://github.com/Keeper-Security/Commander/releases/latest
    sudo installer -store -pkg /tmp/keeper.pkg -target /
    ;;
Linux)
    # Arch is just that easy. Why use any other distro?
    sudo pacman -S keeper-commander
    ;;
Windows)
    # I don't think this will work since these are ps1 commands but it's here when I get around to it:
    # https://stackoverflow.com/a/75334942
    # there's also the exe binary in the releases page for commander that I could manually try to install
    if [ type keeper >/dev/null 2>&1 ]; then
        $URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
        $URL = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json | Select-Object -ExpandProperty "assets" | Where-Object "browser_download_url" -Match '.msixbundle' | Select-Object -ExpandProperty "browser_download_url"
        Invoke-WebRequest -Uri $URL -OutFile "Setup.msix" -UseBasicParsing
        Add-AppxPackage -Path "Setup.msix"
        Remove-Item "Setup.msix"
    fi
    winget install --id=KeeperSecurity.Commander  -e
    ;;
*)
    echo "Unsupported OS for Keeper Commander"
    exit 1
    ;;
esac