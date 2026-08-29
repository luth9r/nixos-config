#!/usr/bin/env bash

# Get current window clients from Hyprland
clients_json=$(hyprctl clients -j)

if [ -z "$clients_json" ] || [ "$clients_json" == "[]" ]; then
    notify-send -a "Window Switcher" "No open windows" "There are no active application windows."
    exit 0
fi

# Collect all system .desktop directories like Rofi drun does
DESKTOP_DIRS=(
    "/home/luther/.local/share/applications"
    "/etc/profiles/per-user/luther/share/applications"
    "/home/luther/.nix-profile/share/applications"
    "/run/current-system/sw/share/applications"
)

# Function to dynamically resolve the exact Icon= from system .desktop entries
get_desktop_icon() {
    local class="$1"
    local lower_class="${class,,}"
    local icon=""

    # 1. Search for direct class.desktop (e.g. firefox.desktop, kitty.desktop, antigravity-ide.desktop)
    for dir in "${DESKTOP_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            for f in "$dir"/*"${lower_class}"*.desktop "$dir"/*"${class}"*.desktop; do
                if [ -f "$f" ]; then
                    icon=$(grep -m1 '^Icon=' "$f" | cut -d'=' -f2)
                    if [ -n "$icon" ]; then
                        echo "$icon"
                        return
                    fi
                fi
            done
        fi
    done

    # Fallback to class name
    echo "$class"
}

declare -A ADDR_MAP
ENTRIES=""

while IFS= read -r line; do
    ws=$(echo "$line" | jq -r '.workspace.id')
    class=$(echo "$line" | jq -r '.class')
    title=$(echo "$line" | jq -r '.title')
    addr=$(echo "$line" | jq -r '.address')

    # Format clean title
    short_title="${title:0:26}"
    if [ ${#title} -gt 26 ]; then
        short_title="${short_title}..."
    fi

    display_name="[WS $ws] $class — $short_title"
    if [ -z "$title" ] || [ "$title" == "null" ]; then
        display_name="[WS $ws] $class"
    fi

    # Automatically extract official application icon from system .desktop files
    icon=$(get_desktop_icon "$class")

    ADDR_MAP["$display_name"]="$addr"
    ENTRIES+="${display_name}\0icon\x1f${icon}\n"
done < <(echo "$clients_json" | jq -c 'sort_by(.workspace.id)[]')

# Open grid view with native system application icons
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
