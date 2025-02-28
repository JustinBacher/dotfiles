#!/bin/bash

# Provided by: https://github.com/JJDizz1L
# Edited by: https://github.com/JustinBacher

update_rustup() {
	rustup update
}

update_yazi() {
	ya pack -u
}

update_hyprpm() {
	hyprpm update
	hyprpm reload
}

update_nvim() {
	# I'm not gonna actually run this but I would
	# like to make this spit out only relevant output
	# at some point. That way i can have it update
	# everything at once but right now it's just
	# too much output.
	nvim --headless "+Lazy! update" +qa
}

install_arch_updates() {
	echo "Updating Arch Linux system..."
	paru -Syu --sudoloop
	install_flatpak_updates
	echo "Updating Rust..."
	update_rustup
	echo "Updating Yazi..."
	update_yazi
	echo "Updating Hyprland Plugin Manager..."
	update_hyprpm
	echo "Done with Arch and AUR updates..."
}

install_ubuntu_updates() {
	echo "Updating Ubuntu system..."
	sudo apt update && sudo apt upgrade -y
	echo "Updating Flatpak packages..."
	flatpak update -y
	echo "Done with Ubuntu updates."
}

install_fedora_updates() {
	echo "Updating Fedora system..."
	sudo dnf update -y
	echo "Updating Flatpak packages..."
	flatpak update -y
	echo "Done with Fedora updates."
}

install_flatpak_updates() {
	echo "Updating Flatpak packages..."
	flatpak update -y
	echo "Done with FlatPak updates."
}

case "$1" in
-arch)
	install_arch_updates
	;;
-ubuntu)
	install_ubuntu_updates
	;;
-fedora)
	install_fedora_updates
	;;
-flatpak)
	install_flatpak_updates
	;;
*)
	echo "Usage: $0 {-arch|-ubuntu|-fedora|-flatpak}"
	;;
esac

echo "Press any key to exit..."
read -n 1
