#!/usr/bin/env bash
# Minimalist Wayland Screenshot Script

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_PATH="$SAVE_DIR/screenshot_$TIMESTAMP.png"

case "$1" in
    full)
        grim "$FILE_PATH"
        wl-copy < "$FILE_PATH"
        notify-send -a "Screenshot" -i "$FILE_PATH" "Fullscreen Screenshot Saved" "$FILE_PATH"
        ;;
    area|*)
        GEOM=$(slurp)
        if [ -n "$GEOM" ]; then
            grim -g "$GEOM" "$FILE_PATH"
            wl-copy < "$FILE_PATH"
            notify-send -a "Screenshot" -i "$FILE_PATH" "Area Screenshot Saved" "$FILE_PATH"
        fi
        ;;
esac
