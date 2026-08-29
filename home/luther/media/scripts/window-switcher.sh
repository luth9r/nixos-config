#!/usr/bin/env bash

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

    # Format clean application name and title
    short_title="${title:0:28}"
    if [ ${#title} -gt 28 ]; then
        short_title="${short_title}..."
    fi

    # Display label: [WS 1] Class - Title
    display_name="[WS $ws] $class — $short_title"
    if [ -z "$title" ] || [ "$title" == "null" ]; then
        display_name="[WS $ws] $class"
    fi

    # Resolve system icon name
    icon="$class"
    icon_lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')

    # Match common window classes to standard desktop icon names
    case "$icon_lower" in
        *kitty*) icon="kitty" ;;
        *firefox*) icon="firefox" ;;
        *zen*) icon="zen" ;;
        *zed*|*zeditor*) icon="dev.zed.Zed" ;;
        *rider*) icon="rider" ;;
        *dolphin*) icon="system-file-manager" ;;
        *discord*) icon="discord" ;;
        *telegram*|*materialgram*) icon="telegram" ;;
        *insomnia*) icon="insomnia" ;;
        *antigravity*) icon="google-antigravity" ;;
        *code*|*visual-studio-code*) icon="code" ;;
        *spotify*) icon="spotify" ;;
        *steam*) icon="steam" ;;
        *vlc*) icon="vlc" ;;
        *celluloid*) icon="celluloid" ;;
        *loupe*) icon="org.gnome.Loupe" ;;
        *) icon="$icon_lower" ;;
    esac

    ADDR_MAP["$display_name"]="$addr"
    ENTRIES+="${display_name}\0icon\x1f${icon}\n"
done < <(echo "$clients_json" | jq -c 'sort_by(.workspace.id)[]')

# Open grid view with large crisp application icons
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
