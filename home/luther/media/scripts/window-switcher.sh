#!/usr/bin/env bash

# Cache directory for window preview cards
CACHE_DIR="/tmp/rofi-window-thumbnails"
mkdir -p "$CACHE_DIR"

# Get current window clients from Hyprland
clients_json=$(hyprctl clients -j)

if [ -z "$clients_json" ] || [ "$clients_json" == "[]" ]; then
    notify-send -a "Window Switcher" "No open windows" "There are no active application windows."
    exit 0
fi

declare -A ADDR_MAP
ENTRIES=""

while IFS= read -r line; do
    ws=$(echo "$line" | jq -r '.workspace.id')
    class=$(echo "$line" | jq -r '.class')
    title=$(echo "$line" | jq -r '.title')
    addr=$(echo "$line" | jq -r '.address')
    at=$(echo "$line" | jq -r '.at | "\(.[0]),\(.[1])"')
    size=$(echo "$line" | jq -r '.size | "\(.[0])x\(.[1])"')

    # Clean display title
    display_name="[WS $ws] $class"
    if [ -n "$title" ]; then
        short_title="${title:0:26}"
        display_name="[WS $ws] $short_title"
    fi

    # Snapshot window if visible on screen
    thumb="$CACHE_DIR/${addr}.png"
    if [ -n "$at" ] && [ -n "$size" ]; then
        grim -g "${at} ${size}" "$thumb" 2>/dev/null || true
    fi

    # Pick thumbnail if valid, otherwise fallback to system icon theme
    icon="$class"
    if [ -f "$thumb" ] && [ -s "$thumb" ]; then
        icon="$thumb"
    fi

    ADDR_MAP["$display_name"]="$addr"
    ENTRIES+="${display_name}\0icon\x1f${icon}\n"
done < <(echo "$clients_json" | jq -c 'sort_by(.workspace.id)[]')

# Open grid view matching the wallpaper picker
THEME_PATH="$HOME/.config/rofi/window.rasi"
ROFI_ARGS=(-dmenu -i -p "󱂬 Windows" -show-icons)
if [ -f "$THEME_PATH" ]; then
    ROFI_ARGS+=(-theme "$THEME_PATH")
fi

CHOSEN=$(printf "%b" "$ENTRIES" | rofi "${ROFI_ARGS[@]}")

if [ -n "$CHOSEN" ]; then
    ADDR="${ADDR_MAP[$CHOSEN]}"
    if [ -n "$ADDR" ]; then
        hyprctl dispatch focuswindow "address:$ADDR"
    fi
fi
