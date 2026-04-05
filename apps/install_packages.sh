#!/usr/bin/env bash

#****************************************************************************
# Filename      : install_packages.sh
# Created       : Sun Apr 5 2026
# Author        : Zolo
# Github        : https://github.com/zolodev
# Description   : Script to install comman applications.
#****************************************************************************

FILE="packages"

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
        return
    fi

    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
        return
    fi

    echo "unknown"
}

OS=$(detect_os)

case "$OS" in
    ubuntu|debian)
        INSTALL="sudo apt install -y"
        UPDATE="sudo apt update"
        ;;
    fedora)
        INSTALL="sudo dnf install -y"
        UPDATE="sudo dnf check-update"
        ;;
    rhel|centos|rocky|almalinux)
        INSTALL="sudo yum install -y"
        UPDATE="sudo yum check-update"
        ;;
    arch)
        INSTALL="sudo pacman -S --noconfirm"
        UPDATE="sudo pacman -Sy"
        ;;
    opensuse*|sles)
        INSTALL="sudo zypper install -y"
        UPDATE="sudo zypper refresh"
        ;;
    macos)
        INSTALL="brew install"
        UPDATE="brew update"
        ;;
    *)
        echo "Unknow OS"
        exit 1
        ;;
esac

echo "Current running OS: $OS"
echo "Using Installer: $INSTALL"

# Update package sources
$UPDATE

# Install packages
while IFS= read -r pkg; do
    if [[ -n "$pkg" ]]; then
        echo "Installing $pkg"
        $INSTALL "$pkg"
    fi
done < "$FILE"
