#!/usr/bin/env bash
# Minimalist Wayland Screenshot Script

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_PATH="$SAVE_DIR/screenshot_$TIMESTAMP.png"

case "$1" in
    full)
        grimblast --freeze copysave output "$FILE_PATH"
        notify-send -a "Screenshot" -i "$FILE_PATH" "Fullscreen Screenshot Saved" "$FILE_PATH"
        ;;
    area|*)
        # --freeze uses Hyprland layer freeze / wlroots freeze to stop all animations/video visually
        grimblast --freeze copysave area "$FILE_PATH"
        if [ -f "$FILE_PATH" ]; then
            notify-send -a "Screenshot" -i "$FILE_PATH" "Area Screenshot Saved" "$FILE_PATH"
        fi
        ;;
esac
