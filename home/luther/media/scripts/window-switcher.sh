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

# Build entries with thumbnail cards and workspace badges
entries=""

while IFS= read -r line; do
    ws=$(echo "$line" | jq -r '.workspace.id')
    class=$(echo "$line" | jq -r '.class')
    title=$(echo "$line" | jq -r '.title')
    addr=$(echo "$line" | jq -r '.address')
    at=$(echo "$line" | jq -r '.at | "\(.[0]),\(.[1])"')
    size=$(echo "$line" | jq -r '.size | "\(.[0])x\(.[1])"')

    # Clean short title
    short_title="${title:0:22}"
    if [ ${#title} -gt 22 ]; then
        short_title="${short_title}..."
    fi

    # Snapshot window if visible on current screen
    thumb="$CACHE_DIR/${addr}.png"
    if [ ! -f "$thumb" ] && [ -n "$at" ] && [ -n "$size" ]; then
        grim -g "${at} ${size}" "$thumb" 2>/dev/null || true
    fi

    # Use large preview thumbnail if exists, else fallback to class icon
    icon="$class"
    if [ -f "$thumb" ] && [ -s "$thumb" ]; then
        icon="$thumb"
    fi

    # Text label under the preview card
    label="[WS $ws] $class\n$short_title"
    entry="$label\0icon\x1f$icon\x1finfo\x1f$addr"

    if [ -z "$entries" ]; then
        entries="$entry"
    else
        entries="${entries}\n${entry}"
    fi
done < <(echo "$clients_json" | jq -c 'sort_by(.workspace.id)[]')

# Open grid view matching the wallpaper picker
selected=$(echo -e "$entries" | rofi -dmenu -i -theme ~/.config/rofi/window.rasi -format "s")

if [ -n "$selected" ]; then
    # Extract address and focus window on Enter
    addr=$(echo "$selected" | grep -o '0x[0-9a-fA-F]*')
    if [ -n "$addr" ]; then
        hyprctl dispatch focuswindow "address:$addr"
    fi
fi
