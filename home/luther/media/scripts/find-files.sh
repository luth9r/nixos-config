#!/usr/bin/env bash
# Interactive fuzzy file finder by name with Bat preview

if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf is required" >&2
    exit 1
fi

FILE=$(fd --type f --hidden --exclude .git 2>/dev/null | fzf --ansi \
    --prompt="find > " \
    --preview='bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {} 2>/dev/null' \
    --preview-window=right:60%:wrap)

if [ -n "$FILE" ]; then
    echo "$FILE"
fi
