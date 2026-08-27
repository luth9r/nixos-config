-- Window Rules and Layer Rules
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
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
