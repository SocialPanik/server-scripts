#!/bin/bash
# Basic system updater for Ubuntu

apt update
apt full-upgrade -y
apt autoremove -y
apt autoclean

if [ -f /var/run/reboot-required ]; then
    echo "⚠️  Reboot is required."
fi
