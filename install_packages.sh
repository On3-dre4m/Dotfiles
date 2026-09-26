#!/bin/bash

# List of packages to install (duplicates removed)
PACKAGES=(
    ## Normal use-case
    "unrar"
    "git"
    "unzip"
    "make"
    "vlc"
    "mpv"
    "xclip"
    "imagemagick"
    "fd-find"
    "ripgrep"
    "fzf"
    ## For i3wm
    "rofi"
    "feh"
    "picom"
    "qalculate-gtk"
    "pavucontrol"
    ## For yazi - file manager
    "exiftool"
)

# Update package cache
echo "Updating package cache with apt..."
sudo apt update
if [ $? -ne 0 ]; then
    echo "Error: Failed to update package cache."
    exit 1
fi

# Install packages
echo "Installing packages: ${PACKAGES[*]}"
sudo apt install "${PACKAGES[@]}"
if [ $? -ne 0 ]; then
    echo "Error: Failed to install one or more packages."
    exit 1
fi

# Clean up
echo "Cleaning up unnecessary packages..."
sudo apt autopurge -y
if [ $? -ne 0 ]; then
    echo "Warning: Failed to clean up unnecessary packages."
fi

echo "Package installation completed successfully!"
exit 0
