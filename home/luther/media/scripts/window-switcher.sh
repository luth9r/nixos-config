#!/usr/bin/env bash

# Get current window clients from Hyprland
clients_json=$(hyprctl clients -j)

if [ -z "$clients_json" ] || [ "$clients_json" == "[]" ]; then
    notify-send -a "Window Switcher" "No open windows" "There are no active application windows."
    exit 0
fi

DESKTOP_DIRS=(
    "/home/luther/.local/share/applications"
    "/etc/profiles/per-user/luther/share/applications"
    "/home/luther/.nix-profile/share/applications"
    "/run/current-system/sw/share/applications"
)

get_desktop_icon() {
    local class="$1"
    local lower_class="${class,,}"
    local icon=""

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

    echo "$class"
}

ENTRIES=""
declare -a WORKSPACE_ARR
declare -a ADDR_ARR

index=0
while IFS= read -r line; do
    ws=$(echo "$line" | jq -r '.workspace.id')
    class=$(echo "$line" | jq -r '.class')
    title=$(echo "$line" | jq -r '.title')
    addr=$(echo "$line" | jq -r '.address')

    short_title="${title:0:26}"
    if [ ${#title} -gt 26 ]; then
        short_title="${short_title}..."
    fi

    display_name="[WS $ws] $class — $short_title"
    if [ -z "$title" ] || [ "$title" == "null" ]; then
        display_name="[WS $ws] $class"
    fi

    icon=$(get_desktop_icon "$class")

    WORKSPACE_ARR[$index]="$ws"
    ADDR_ARR[$index]="$addr"
    ENTRIES+="${display_name}\0icon\x1f${icon}\n"
    ((index++))
done < <(echo "$clients_json" | jq -c 'sort_by(.workspace.id)[]')

THEME_PATH="$HOME/.config/rofi/window.rasi"
ROFI_ARGS=(-dmenu -i -p "󱂬 Windows" -show-icons -format "i")
if [ -f "$THEME_PATH" ]; then
    ROFI_ARGS+=(-theme "$THEME_PATH")
fi

# Rofi returns the 0-based selected index directly (-format i)
SELECTED_INDEX=$(printf "%b" "$ENTRIES" | rofi "${ROFI_ARGS[@]}")

if [ -n "$SELECTED_INDEX" ] && [ "$SELECTED_INDEX" -ge 0 ] 2>/dev/null; then
    TARGET_WS="${WORKSPACE_ARR[$SELECTED_INDEX]}"
    TARGET_ADDR="${ADDR_ARR[$SELECTED_INDEX]}"

    # 1. Switch directly to the window's workspace
    if [ -n "$TARGET_WS" ]; then
        hyprctl dispatch workspace "$TARGET_WS"
    fi

    # 2. Focus the exact window on that workspace
    if [ -n "$TARGET_ADDR" ]; then
        hyprctl dispatch focuswindow "address:$TARGET_ADDR"
    fi
fi
