#!/usr/bin/env bash
set -euo pipefail

pci_devices_root=${PCI_DEVICES_ROOT:-/sys/bus/pci/devices}
package=ollama

for device in "$pci_devices_root"/*; do
    [[ -r "$device/vendor" && -r "$device/class" ]] || continue
    IFS= read -r vendor <"$device/vendor"
    IFS= read -r class <"$device/class"

    if [[ ${vendor,,} == 0x10de && ${class,,} == 0x03* ]]; then
        package=ollama-cuda
        break
    fi
done

echo "installing $package"
"${PARU_BIN:-paru}" -S --needed --noconfirm "$package"
