#!/usr/bin/env bash
# Interactive Ripgrep + FZF search with Bat preview

if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf is required" >&2
    exit 1
fi

MATCH=$(rg --color=always --line-number --no-heading --smart-case "" 2>/dev/null | fzf --ansi \
    --delimiter=: \
    --prompt="grep > " \
    --preview='bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || cat {1} 2>/dev/null' \
    --preview-window=right:60%:wrap)

if [ -n "$MATCH" ]; then
    FILE=$(echo "$MATCH" | cut -d: -f1)
    echo "$FILE"
fi
