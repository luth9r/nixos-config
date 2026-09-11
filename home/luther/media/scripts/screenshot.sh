#!/usr/bin/env bash
# Windows-style Wayland Screenshot Utility using grimblast

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_PATH="$SAVE_DIR/screenshot_$TIMESTAMP.png"


case "$1" in
    edit)
        # Interactive editor with freeze and area selection
        grimblast --freeze save area - | satty --filename - --output-filename "$FILE_PATH"
        ;;
    full)
        # Fullscreen instant capture
        grimblast copysave screen "$FILE_PATH"
        ;;
    area|quick|*)
        # Area/window capture to clipboard & folder
        grimblast --freeze copysave area "$FILE_PATH"
        ;;
esac
