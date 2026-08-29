-- Window Rules and Layer Rules
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "focus-media-viewers",
    match = { class = "(org.gnome.Loupe|org.kde.gwenview|io.github.celluloid_player.Celluloid|mpv|vlc|org.kde.ark|dev.zed.Zed|org.kde.okular)" },
    focus_on_activate = true,
})

hl.window_rule({
    name = "float-pavucontrol",
    match = { class = "pavucontrol" },
    float = true,
})

hl.window_rule({
    name = "float-nm-connection-editor",
    match = { class = "nm-connection-editor" },
    float = true,
})

hl.window_rule({
    name = "float-btop",
    match = { class = "btop" },
    float = true,
})

hl.window_rule({
    name = "float-file-roller",
    match = { class = "org.gnome.FileRoller" },
    float = true,
})

hl.window_rule({
    name = "float-media-players",
    match = { class = "(mpv|io.github.celluloid_player.Celluloid|vlc)" },
    float = true,
})

hl.window_rule({
    name = "float-pip",
    match = { title = "Picture-in-Picture" },
    float = true,
    pin = true,
})

hl.window_rule({
    name = "idleinhibit-fullscreen",
    match = { fullscreen = true },
    idle_inhibit = "fullscreen",
})

-- File Chooser & Open/Save File Dialogs (Centered & Sized)
hl.window_rule({
    name = "float-file-pickers",
    match = { class = ".*(portal|kdialog).*" },
    float = true,
    center = true,
    size = { 1000, 600 },
})

hl.window_rule({
    name = "float-file-dialog-titles",
    match = { title = ".*(Open File|Save File|Choose Files|All Files|Select a Directory|Open Folder|Save As|Upload|File Upload).*" },
    float = true,
    center = true,
    size = { 1000, 600 },
})
