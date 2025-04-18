#!/bin/bash
# update-system.sh

set -e

echo "🔄 Updating package index..."
apt update

echo "⬆️  Performing full upgrade..."
apt full-upgrade -y

echo "🧹 Cleaning up..."
apt autoremove -y
apt autoclean

echo "🧼 Removing old kernels (keeping the last 2)..."
# Get list of installed kernels (not the currently running one)
current_kernel=$(uname -r)
kernels_to_remove=$(dpkg --list | grep 'linux-image-[0-9]' | awk '{ print $2 }' | grep -v "$current_kernel" | sort -V | head -n -2)

if [ -n "$kernels_to_remove" ]; then
    echo "Removing old kernels:"
    echo "$kernels_to_remove"
    apt purge -y $kernels_to_remove
else
    echo "✅ No old kernels to remove."
fi

# Check if reboot is needed
if [ -f /var/run/reboot-required ]; then
    echo "⚠️  Reboot is required. Rebooting now..."
    reboot
else
    echo "✅ No reboot required."
fi
