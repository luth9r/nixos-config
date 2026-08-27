#!/usr/bin/env bash
# Fast Wallpaper Switcher with Visual Rofi Thumbnail Previews

WALLPAPER_DIR="$HOME/dotfiles/wallpapers"
CURRENT_WALL_LINK="$HOME/.cache/current_wallpaper"

mkdir -p "$HOME/.cache"
mkdir -p "$WALLPAPER_DIR"

if [ "$1" == "--init" ]; then
    if [ -f "$CURRENT_WALL_LINK" ]; then
        WALL=$(cat "$CURRENT_WALL_LINK" 2>/dev/null || echo "")
        if [ ! -f "$WALL" ]; then
            WALL="$WALLPAPER_DIR/default.jpg"
            [ ! -f "$WALL" ] && WALL="$WALLPAPER_DIR/default.png"
        fi
    elif [ -f "$WALLPAPER_DIR/default.jpg" ]; then
        WALL="$WALLPAPER_DIR/default.jpg"
    elif [ -f "$WALLPAPER_DIR/default.png" ]; then
        WALL="$WALLPAPER_DIR/default.png"
    else
        exit 0
    fi
elif [ -n "$1" ] && [ -f "$1" ]; then
    WALL="$(realpath "$1")"
else
    # Interactively pick wallpaper using visual Rofi thumbnail gallery
    declare -A WALL_MAP
    ENTRIES=""

    while IFS= read -r file; do
        if [ -f "$file" ]; then
            NAME="$(basename "$file")"
            if [ -n "${WALL_MAP[$NAME]}" ] && [ "${WALL_MAP[$NAME]}" != "$file" ]; then
                NAME="$(basename "$(dirname "$file")") / $NAME"
            fi
            WALL_MAP["$NAME"]="$file"
            ENTRIES+="${NAME}\0icon\x1f${file}\n"
        fi
    done < <(find "$WALLPAPER_DIR" "$HOME/Pictures" -maxdepth 3 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" -o -name "*.jpeg" -o -name "*.avif" \) 2>/dev/null | sort -u)

    if [ -z "$ENTRIES" ]; then
        exit 0
    fi

    THEME_PATH="$HOME/.config/rofi/wallpaper.rasi"
    ROFI_ARGS=(-dmenu -i -p "󰸉 Wallpapers" -show-icons)
    if [ -f "$THEME_PATH" ]; then
        ROFI_ARGS+=(-theme "$THEME_PATH")
    fi

    CHOSEN=$(printf "%b" "$ENTRIES" | rofi "${ROFI_ARGS[@]}")

    if [ -z "$CHOSEN" ]; then
        exit 0
    fi

    WALL="${WALL_MAP[$CHOSEN]}"
    if [ -z "$WALL" ] || [ ! -f "$WALL" ]; then
        if [ -f "$CHOSEN" ]; then
            WALL="$CHOSEN"
        else
            exit 0
        fi
    fi
fi

# Save current wallpaper path
echo "$WALL" > "$CURRENT_WALL_LINK"

# Set wallpaper instantly
if command -v awww >/dev/null 2>&1; then
    if ! pgrep -f "awww-daemon" > /dev/null; then
        awww-daemon &
    fi
    awww img "$WALL" --transition-type wipe --transition-step 90 --transition-fps 60 2>/dev/null || true
elif command -v wayle >/dev/null 2>&1; then
    wayle wallpaper set "$WALL" 2>/dev/null || true
fi
