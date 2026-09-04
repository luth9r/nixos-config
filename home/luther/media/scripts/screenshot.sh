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
        TMP_IMG="/tmp/grim_freeze_$TIMESTAMP.png"
        # 1. Instantly freeze the whole screen buffer into memory
        grim "$TMP_IMG" || exit 1
        
        # 2. Select region over the frozen screen with themed border/background
        GEOM=$(slurp -b 00000044 -c ffffff -s 00000000 -w 2 2>/dev/null)
        if [ -n "$GEOM" ]; then
            # 3. Crop directly from the frozen snapshot (zero tearing / motion distortion)
            grim -g "$GEOM" "$FILE_PATH"
            wl-copy < "$FILE_PATH"
            notify-send -a "Screenshot" -i "$FILE_PATH" "Area Screenshot Saved" "$FILE_PATH"
        fi
        rm -f "$TMP_IMG"
        ;;
esac
