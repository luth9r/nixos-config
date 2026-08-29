#!/usr/bin/env bash
# Fast Cached Hyprland Keybindings Cheatsheet for Rofi
# Compiles on startup/reload to /tmp/hypr-cheatsheet.txt; opens instantly (< 20ms)

CACHE_FILE="/tmp/hypr-cheatsheet.txt"
KEYBINDS_FILE="$HOME/.config/hypr/keybinds.lua"

# Function to compile keybindings list
compile_cheatsheet() {
    if [ ! -f "$KEYBINDS_FILE" ]; then
        return
    fi

    local -A CATEGORIES
    local -a CATEGORIES_ORDER
    local -A SEEN_BINDS

    while IFS= read -r line; do
        [[ -z "$line" || ("$line" =~ ^[[:space:]]*-- && ! "$line" =~ description) ]] && continue
        
        if [[ "$line" =~ description[[:space:]]*=[[:space:]]*[\"\']([^\"\']+)[\"\'] ]]; then
            raw_desc="${BASH_REMATCH[1]}"
            raw_desc="${raw_desc//\"/}"
            raw_desc="${raw_desc//\'/}"
            raw_desc=$(echo "$raw_desc" | sed -E 's/[[:space:]]+/ /g' | xargs)
            
            [[ "$raw_desc" != *":"* ]] && continue
            
            category=$(echo "$raw_desc" | cut -d':' -f1 | xargs)
            action=$(echo "$raw_desc" | cut -d':' -f2- | xargs)
            
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
                        elif [[ "$raw_key" == *"SHIFT"* ]]; then
                            key="SUPER + SHIFT + 1..0"
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

    local output=""
    for cat in "${CATEGORIES_ORDER[@]}"; do
        icon=$(get_icon "$cat")
        cat_upper=$(echo "$cat" | tr '[:lower:]' '[:upper:]')
        output+="── [ $icon  $cat_upper ] ──────────────────────────\n"
        output+="${CATEGORIES[$cat]}\n"
    done

    printf "%b" "$output" > "$CACHE_FILE"
}

# If called with --compile, just generate cache and exit
if [ "$1" == "--compile" ]; then
    compile_cheatsheet
    exit 0
fi

# If cache does not exist or keybinds file is newer, compile
if [ ! -f "$CACHE_FILE" ] || [ "$KEYBINDS_FILE" -nt "$CACHE_FILE" ]; then
    compile_cheatsheet
fi

# Instant zero-latency launch from precompiled cache
rofi -dmenu -i -p "󰌌 Shortcuts" \
  -theme-str '
    window { width: 780px; height: 620px; }
    listview { lines: 16; columns: 1; }
    entry { placeholder: "Search keybindings (apps, window, media, etc)..."; }
  ' < "$CACHE_FILE"
