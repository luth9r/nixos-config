#!/usr/bin/env bash

# Query open windows from Hyprland sorted by workspace ID
windows=$(hyprctl clients -j | jq -r '
  sort_by(.workspace.id)[] | 
  "[\(.workspace.id)] \(.class) — \(.title)\u0000icon\u001f\(.class)\u001finfo\u001f\(.address)"
')

if [ -z "$windows" ]; then
    notify-send -a "Window Switcher" "No open windows" "There are no active application windows."
    exit 0
fi

# Show in Rofi with workspace badge and application icon
selected=$(echo -en "$windows" | rofi -dmenu -i -p "Windows" -theme-str 'listview { lines: 10; }' -format "s")

if [ -n "$selected" ]; then
    # Extract window address from the metadata
    addr=$(echo "$selected" | grep -o '0x[0-9a-fA-F]*')
    if [ -n "$addr" ]; then
        hyprctl dispatch focuswindow "address:$addr"
    fi
fi
