#!/usr/bin/env bash
# Interactive fuzzy file finder with intelligent preview (Code via Bat, Images via Chafa)

if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf is required" >&2
    exit 1
fi

PREVIEW_CMD='
file="{}"
mime=$(file --mime-type -b "$file" 2>/dev/null)
case "$mime" in
    image/*)
        if command -v chafa >/dev/null 2>&1; then
            chafa --size=60x30 --clear "$file" 2>/dev/null
        else
            echo "[Image file: $file]"
        fi
        ;;
    application/pdf)
        echo "[PDF Document: $file]"
        ;;
    *)
        bat --style=numbers --color=always --line-range :500 "$file" 2>/dev/null || cat "$file" 2>/dev/null
        ;;
esac
'

FILE=$(fd --type f --hidden --exclude .git 2>/dev/null | fzf --ansi \
    --prompt="find > " \
    --preview="$PREVIEW_CMD" \
    --preview-window=right:60%:wrap)

if [ -n "$FILE" ]; then
    echo "$FILE"
fi
