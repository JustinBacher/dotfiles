#!/usr/bin/env sh

set -o nounset -o pipefail -o errexit

install="sudo paru -S --noconfirm --needed"

pacman -Syy
pacman -Syu

# Make symlinks for system files so chezmoi can manage them
sudo rm -f /etc/pacman.conf
sudo ln -sf ~/.config/pacman/pacman.conf /etc/pacman.conf

# Install paru so we can install aurs and regualar packages with ease
sudo pacman -S --needed git base-devel
# Need to install and configure rustup because I've had issues with not installing it first
sudo pacman -S rustup
rustup default stable
git clone https://aur.archlinux.org/paru.git
pushd paru
makepkg -si
popd

# If we are working with an nvidia card then install the modules and add to initramfs
# https://github.com/prasanthrangan/hyprdots/blob/911d625607a9ab10b99a0ce5437eaa942c9479cd/Scripts/.extra/install_mod.sh#L7
if [ $(lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i nvidia | wc -l) -gt 0 ]; then
	"$install nvidia-dkms nvidia-utils egl-wayland"
	if [ $(grep 'MODULES=' /etc/mkinitcpio.conf | grep nvidia | wc -l) -eq 0 ]; then
		sudo sed -i "/MODULES=/ s/)$/ nvidia nvidia_modeset nvidia_uvm nvidia_drm)/" /etc/mkinitcpio.conf
		sudo mkinitcpio -P
		if [ $(grep 'options nvidia-drm modeset=1' /etc/modprobe.d/nvidia.conf | wc -l) -eq 0 ]; then
			echo 'options nvidia-drm modeset=1' | sudo tee -a /etc/modprobe.d/nvidia.conf
		fi
	fi
fi

# Install all the other modules
"$install < ~/.config/pacman/packages.lst"
