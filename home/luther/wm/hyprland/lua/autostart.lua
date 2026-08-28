-- Startup Daemons and Applications
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    -- Import environment variables into DBus and Systemd user session
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_DATA_DIRS PATH GTK_USE_PORTAL")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_DATA_DIRS PATH GTK_USE_PORTAL")

    -- Restart and ensure XDG Desktop Portals are active with current session environment
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal-hyprland plasma-xdg-desktop-portal-kde 2>/dev/null || true")
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal 2>/dev/null || bash -c 'sleep 1; $(find /nix/store -maxdepth 3 -name xdg-desktop-portal -type f -perm /111 | head -n 1) --replace &'")

    -- KDE Polkit authentication agent (sudo/admin password dialogs, disk mounting)
    hl.exec_cmd("bash -c '$(find /run/current-system/sw/libexec /nix/store -maxdepth 4 -name polkit-kde-authentication-agent-1 -type f -perm /111 2>/dev/null | head -n 1) &'")

    -- Wallpaper daemon & initial wallpaper setup
    hl.exec_cmd("awww-daemon || swww-daemon")
    hl.exec_cmd("~/.config/hypr/scripts/change-wall.sh --init")

    -- Wayle Desktop Bar, Notification Daemon & Control Center
    hl.exec_cmd("pkill -x wayle; wayle shell")

    -- Idle & Lock daemon
    hl.exec_cmd("hypridle")

    -- Clipboard Manager
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Build KDE application service cache for Dolphin "Open With" dialog
    hl.exec_cmd("kbuildsycoca6 --noincremental 2>/dev/null || true")
end)
