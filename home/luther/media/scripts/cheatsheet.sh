#!/usr/bin/env bash
# Pure Bash Dynamic Hyprland Keybindings Parser for Rofi
# Parses `description = "Category: Action"` directly from ~/.config/hypr/keybinds.lua

KEYBINDS_FILE="$HOME/.config/hypr/keybinds.lua"
if [ ! -f "$KEYBINDS_FILE" ]; then
    KEYBINDS_FILE="$HOME/dotfiles/home/luther/wm/hyprland/lua/keybinds.lua"
fi

if [ ! -f "$KEYBINDS_FILE" ]; then
    exit 0
fi

# Load application variables from vars.lua if available
VARS_FILE="$HOME/.config/hypr/vars.lua"
declare -A APP_VARS=(
    ["terminal"]="Kitty"
    ["browser"]="Firefox"
    ["editor"]="Zed"
    ["file_manager"]="Dolphin"
)

if [ -f "$VARS_FILE" ]; then
    while IFS='=' read -r key val; do
        k=$(echo "$key" | xargs)
        v=$(echo "$val" | tr -d '",'"'" | xargs)
        if [ -n "$k" ] && [ -n "$v" ]; then
            if [ "$v" = "zeditor" ]; then v="Zed"; else v="$(tr '[:lower:]' '[:upper:]' <<< "${v:0:1}")${v:1}"; fi
            APP_VARS["$k"]="$v"
        fi
    done < <(grep -E '^\s*(terminal|browser|editor|file_manager)\s*=' "$VARS_FILE" 2>/dev/null)
fi

# Parse keybindings dynamically from description tags
declare -A CATEGORIES
CATEGORIES_ORDER=()
declare -A SEEN_BINDS

while IFS= read -r line; do
    # Skip empty lines or pure comment lines without description
    [[ -z "$line" || ("$line" =~ ^[[:space:]]*-- && ! "$line" =~ description) ]] && continue
    
    # Match description tag
    if [[ "$line" =~ description[[:space:]]*=[[:space:]]*[\"\']([^\"\']+)[\"\'] ]]; then
        raw_desc="${BASH_REMATCH[1]}"
        
        # Replace variable placeholders in description
        for var_name in "${!APP_VARS[@]}"; do
            raw_desc="${raw_desc//format_app_name($var_name)/${APP_VARS[$var_name]}}"
            raw_desc="${raw_desc//$var_name/${APP_VARS[$var_name]}}"
        done
        raw_desc="${raw_desc//\"/}"
        raw_desc="${raw_desc//\'/}"
        raw_desc="${raw_desc//\.\./}"
        raw_desc=$(echo "$raw_desc" | sed -E 's/[[:space:]]+/ /g' | xargs)
        
        [[ "$raw_desc" != *":"* ]] && continue
        
        category=$(echo "$raw_desc" | cut -d':' -f1 | xargs)
        action=$(echo "$raw_desc" | cut -d':' -f2- | xargs)
        
        # Extract Key
        key=""
        if [[ "$line" =~ hl\.bind\(([^\,]+) ]]; then
            raw_key="${BASH_REMATCH[1]}"
            raw_key="${raw_key//mainMod/SUPER}"
            raw_key="${raw_key//\.\./}"
            raw_key="${raw_key//\"/}"
            raw_key="${raw_key//\'/}"
            raw_key=$(echo "$raw_key" | sed -E 's/[[:space:]]*\+[[:space:]]*/ + /g' | xargs)
            
            case "$raw_key" in
                "SUPER_L") key="SUPER (Tap)" ;;
                *"key"*)
                    if [[ "$raw_key" == *"ALT"* ]]; then
                        key="SUPER + ALT + 1..0"
                    else
                        key="SUPER + 1..0"
                    fi
                    ;;
                "mouse_up") key="SUPER + Wheel Up" ;;
                "mouse_down") key="SUPER + Wheel Down" ;;
                *"mouse:272"*) key="SUPER + Left Drag" ;;
                *"mouse:273"*) key="SUPER + Right Drag" ;;
                *"slash"*) key="${raw_key//slash//}" ;;
                *) key="$raw_key" ;;
            esac
        fi
        
        [[ -z "$key" || -z "$action" ]] && continue
        
        # Check uniqueness to prevent duplicates in loops
        unique_sig="${category}|${key}|${action}"
        if [ -z "${SEEN_BINDS[$unique_sig]}" ]; then
            SEEN_BINDS["$unique_sig"]=1
            
            if [ -z "${CATEGORIES[$category]}" ]; then
                CATEGORIES_ORDER+=("$category")
            fi
            printf -v formatted_entry "%-26s   %s\n" "$key" "$action"
            CATEGORIES["$category"]+="$formatted_entry"
        fi
    fi
done < "$KEYBINDS_FILE"

# Build visual grouped list with category icons
OUTPUT=""
get_icon() {
    case "$1" in
        "Apps") echo "" ;;
        "Window") echo "" ;;
        "Navigation") echo "󰍹" ;;
        "Workspaces") echo "" ;;
        "Screenshot") echo "󰄀" ;;
        "Recording") echo "󰻃" ;;
        "Media") echo "󰕾" ;;
        "System") echo "󰌌" ;;
        "Rice") echo "󰏘" ;;
        *) echo "󰌌" ;;
    esac
}

for cat in "${CATEGORIES_ORDER[@]}"; do
    icon=$(get_icon "$cat")
    cat_upper=$(echo "$cat" | tr '[:lower:]' '[:upper:]')
    OUTPUT+="── [ $icon  $cat_upper ] ──────────────────────────\n"
    OUTPUT+="${CATEGORIES[$cat]}\n"
done

printf "%b" "$OUTPUT" | rofi -dmenu -i -p "󰌌 Shortcuts" -theme-str '
window { width: 780px; height: 620px; }
listview { lines: 16; columns: 1; }
entry { placeholder: "Search keybindings (apps, window, media, etc)..."; }
'
