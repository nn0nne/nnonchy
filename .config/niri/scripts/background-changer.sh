#!/usr/bin/env bash
set -e

IMG="$HOME/dotfiles/wallpapers/radio-tower-night.png"
SRC="${1:-$IMG}"

# ---- i3 ----
I3_WALL="$HOME/.config/i3/wallpaper.png"
ln -sf "$SRC" "$I3_WALL"

# ---- MangoWC ----
MANGOWC_WALL="$HOME/.config/mango/wallpaper.png"
ln -sf "$SRC" "$MANGOWC_WALL"

# ---- Limine ----
LIMINE_WALL="/boot/limine-splash.png"
sudo cp "$SRC" "$LIMINE_WALL"

echo "Wallpaper updated."
