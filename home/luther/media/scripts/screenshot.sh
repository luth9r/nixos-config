#!/usr/bin/env bash
# Minimalist Wayland Screenshot Script

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_PATH="$SAVE_DIR/screenshot_$TIMESTAMP.png"

case "$1" in
    full)
        grim - | satty --filename - --output-filename "$FILE_PATH"
        ;;
    area|*)
        GEOM=$(slurp -b 00000055 -c ffffff -s 00000000 -w 2)
        if [ -n "$GEOM" ]; then
            grim -g "$GEOM" - | satty --filename - --output-filename "$FILE_PATH"
        fi
        ;;
esac
