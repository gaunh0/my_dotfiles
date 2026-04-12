#!/bin/bash
# Usage: set-wallpaper.sh /path/to/image.jpg
BG_FILE="$HOME/resource/dotfiles/wallpaper/wallhaven-m3x62m.jpg"
# BG_FILE="$HOME/.config/background/painted-valley.jpg"

# Apply wallpaper instantly
pkill swaybg 2>/dev/null
swaybg -i "$BG_FILE" -m fill &
