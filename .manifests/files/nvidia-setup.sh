#!/usr/bin/env bash
# NVIDIA only: put the nvidia modules in the initramfs and enable DRM modeset.
# The driver packages come from packages.yaml. Root steps call sudo directly.
set -euo pipefail

if ! lspci -k | grep -A2 -E 'VGA|3D' | grep -qi nvidia; then
    echo "no NVIDIA GPU found; skipping"
    exit 0
fi

if ! grep -E '^MODULES=' /etc/mkinitcpio.conf | grep -q nvidia; then
    sudo sed -i '/^MODULES=/ s/)$/ nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
fi

if ! grep -q 'options nvidia-drm modeset=1' /etc/modprobe.d/nvidia.conf 2>/dev/null; then
    echo 'options nvidia-drm modeset=1' | sudo tee -a /etc/modprobe.d/nvidia.conf >/dev/null
fi
