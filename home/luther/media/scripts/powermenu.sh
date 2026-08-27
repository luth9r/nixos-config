#!/usr/bin/env bash
# Minimalist Rofi Power Menu

OPTIONS=" Lock\n Suspend\n Logout\n Reboot\n Shutdown"

CHOSEN=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Power Menu")

case "$CHOSEN" in
    " Lock")
        hyprlock
        ;;
    " Suspend")
        systemctl suspend
        ;;
    " Logout")
        hyprctl dispatch 'hl.dsp.exit()' 2>/dev/null || loginctl terminate-user "$USER"
        ;;
    " Reboot")
        systemctl reboot
        ;;
    " Shutdown")
        systemctl poweroff
        ;;
esac
