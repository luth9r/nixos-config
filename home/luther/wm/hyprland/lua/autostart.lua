-- Startup Daemons and Applications
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    -- Polkit authentication agent
    hl.exec_cmd("/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1")

    -- Wallpaper daemon & initial wallpaper setup
    hl.exec_cmd("awww-daemon || swww-daemon")
    hl.exec_cmd("~/.config/hypr/scripts/change-wall.sh --init")

    -- Wayle Desktop Bar, Notification Daemon & Control Center
    hl.exec_cmd("wayle shell")

    -- Idle & Lock daemon
    hl.exec_cmd("hypridle")

    -- Clipboard Manager
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
