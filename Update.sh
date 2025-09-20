#!/bin/bash
# update-system.sh
# Unified update script for Ubuntu, Mint, Kubuntu, and Ubuntu Server

set -e

echo "🔄 Updating package index..."
sudo apt update

echo "⬆️  Performing full upgrade..."
sudo apt full-upgrade -y

echo "🧹 Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

echo "🧼 Removing old kernels (keeping the last 2)..."
# Get list of installed kernels (not the currently running one)
current_kernel=$(uname -r)
kernels_to_remove=$(dpkg --list | grep 'linux-image-[0-9]' | awk '{ print $2 }' | grep -v "$current_kernel" | sort -V | head -n -2)

if [ -n "$kernels_to_remove" ]; then
    echo "Removing old kernels:"
    echo "$kernels_to_remove"
    sudo apt purge -y $kernels_to_remove
else
    echo "✅ No old kernels to remove."
fi

echo "📦 Checking for Snap..."
if command -v snap >/dev/null 2>&1; then
    echo "⬆️  Updating Snaps..."
    sudo snap refresh
else
    echo "ℹ️  Snap not installed."
fi

echo "📦 Checking for Flatpak..."
if command -v flatpak >/dev/null 2>&1; then
    echo "⬆️  Updating Flatpaks..."
    flatpak update -y
else
    echo "ℹ️  Flatpak not installed."
fi

# Check if reboot is needed
if [ -f /var/run/reboot-required ]; then
    echo "⚠️  Reboot is required."
    read -p "Would you like to reboot now? (y/N): " answer
    case "$answer" in
        [Yy]* ) echo "🔄 Rebooting..."; sudo reboot;;
        * ) echo "✅ Skipping reboot for now.";;
    esac
else
    echo "✅ No reboot required."
fi
