#!/usr/bin/env bash
# Minimalist Wayland Screenshot Script

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_PATH="$SAVE_DIR/screenshot_$TIMESTAMP.png"

case "$1" in
    edit)
        # Interactive Satty annotation editor (Print)
        GEOM=$(slurp -b 00000055 -c ffffff -s 00000000 -w 2)
        if [ -n "$GEOM" ]; then
            grim -g "$GEOM" - | satty --filename - --output-filename "$FILE_PATH"
        fi
        ;;
    full)
        grim "$FILE_PATH"
        wl-copy < "$FILE_PATH"
        notify-send -a "Screenshot" -i "$FILE_PATH" "Fullscreen Screenshot Saved" "$FILE_PATH"
        ;;
    area|quick|*)
        # Instant capture to clipboard & folder (Super + Shift + S)
        GEOM=$(slurp -b 00000055 -c ffffff -s 00000000 -w 2)
        if [ -n "$GEOM" ]; then
            grim -g "$GEOM" "$FILE_PATH"
            wl-copy < "$FILE_PATH"
            notify-send -a "Screenshot" -i "$FILE_PATH" "Screenshot Saved & Copied" "$FILE_PATH"
        fi
        ;;
esac
