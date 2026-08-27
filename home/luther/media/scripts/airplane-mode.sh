#!/usr/bin/env bash
# Centralized Airplane Mode Toggle (Wi-Fi + Bluetooth)
# Fully syncs with NetworkManager D-Bus, BlueZ D-Bus, Linux RFKill, and Wayle Dashboard

STATE_FILE="$HOME/.cache/airplane_mode"
mkdir -p "$HOME/.cache"

# Check if currently in airplane mode
if [ -f "$STATE_FILE" ]; then
    # Disable Airplane Mode -> Enable all networks & Bluetooth
    rm -f "$STATE_FILE"
    rfkill unblock all 2>/dev/null || true
    nmcli networking on 2>/dev/null || true
    nmcli radio all on 2>/dev/null || true
    if command -v bluetoothctl >/dev/null 2>&1; then
        bluetoothctl power on 2>/dev/null || true
    fi
    notify-send -a "System" -i "network-wireless-symbolic" "Airplane Mode: OFF" "Wi-Fi and Bluetooth enabled"
else
    # Enable Airplane Mode -> Disable all networks & Bluetooth
    touch "$STATE_FILE"
    nmcli radio all off 2>/dev/null || true
    nmcli networking off 2>/dev/null || true
    if command -v bluetoothctl >/dev/null 2>&1; then
        bluetoothctl power off 2>/dev/null || true
    fi
    rfkill block all 2>/dev/null || true
    notify-send -a "System" -i "airplane-mode-symbolic" "Airplane Mode: ON" "All network radios disabled"
fi
