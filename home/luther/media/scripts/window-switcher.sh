#!/usr/bin/env bash

# Directory for cached window thumbnails
CACHE_DIR="/tmp/rofi-window-thumbnails"
mkdir -p "$CACHE_DIR"

# Get current window clients from Hyprland
clients_json=$(hyprctl clients -j)

if [ -z "$clients_json" ] || [ "$clients_json" == "[]" ]; then
    notify-send -a "Window Switcher" "No open windows" "There are no active application windows."
    exit 0
fi

# Build entries with workspace indicator and window icons/thumbnails
entries=""

while IFS= read -r line; do
    ws=$(echo "$line" | jq -r '.workspace.id')
    class=$(echo "$line" | jq -r '.class')
    title=$(echo "$line" | jq -r '.title')
    addr=$(echo "$line" | jq -r '.address')
    at=$(echo "$line" | jq -r '.at | "\(.[0]),\(.[1])"')
    size=$(echo "$line" | jq -r '.size | "\(.[0])x\(.[1])"')

    # Truncate long titles cleanly
    short_title="${title:0:45}"
    if [ ${#title} -gt 45 ]; then
        short_title="${short_title}..."
    fi

    # Snapshot window if visible on current screen or use class icon
    thumb="$CACHE_DIR/${addr}.png"
    if [ ! -f "$thumb" ] && [ -n "$at" ] && [ -n "$size" ]; then
        # Quick silent snapshot via grim
        grim -g "${at} ${size}" "$thumb" 2>/dev/null || true
    fi

    # If thumbnail exists, use it as preview icon; otherwise fallback to app icon
    icon="$class"
    if [ -f "$thumb" ] && [ -s "$thumb" ]; then
        icon="$thumb"
    fi

    entry="[WS $ws]  $class  —  $short_title\0icon\x1f$icon\x1finfo\x1f$addr"
    if [ -z "$entries" ]; then
        entries="$entry"
    else
        entries="${entries}\n${entry}"
    fi
done < <(echo "$clients_json" | jq -c 'sort_by(.workspace.id)[]')

# Show in Rofi with preview thumbnails and workspace badges
selected=$(echo -e "$entries" | rofi -dmenu -i -p "Windows" \
  -theme-str 'window { width: 680px; height: 500px; } listview { lines: 8; } element-icon { size: 36px; border-radius: 6px; }' \
  -format "s")

if [ -n "$selected" ]; then
    addr=$(echo "$selected" | grep -o '0x[0-9a-fA-F]*')
    if [ -n "$addr" ]; then
        hyprctl dispatch focuswindow "address:$addr"
    fi
fi
