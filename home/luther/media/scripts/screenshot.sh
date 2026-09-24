#!/usr/bin/env bash
# Windows-style Wayland Screenshot Utility using grimblast

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_PATH="$SAVE_DIR/screenshot_$TIMESTAMP.png"


# Check if grimblast is installed globally, otherwise use nix run
if command -v grimblast >/dev/null 2>&1; then
    GRIMBLAST_CMD="grimblast"
else
    GRIMBLAST_CMD="nix run nixpkgs#grimblast --"
fi

case "$1" in
    edit)
        # Interactive editor with freeze and area selection
        $GRIMBLAST_CMD --freeze save area - | satty --filename - --output-filename "$FILE_PATH"
        ;;
    full)
        # Fullscreen instant capture
        $GRIMBLAST_CMD copysave screen "$FILE_PATH"
        ;;
    area|quick|*)
        # Area/window capture to clipboard & folder
        $GRIMBLAST_CMD --freeze copysave area "$FILE_PATH"
        ;;
esac
