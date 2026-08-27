-- General & Input configuration
-- Dynamically parameterized via vars.lua
-- See https://wiki.hypr.land/Configuring/Basics/Variables/

local vars = require("vars")
local colors = require("colors")

hl.config({
    general = {
        gaps_in = vars.gaps_in or 4,
        gaps_out = vars.gaps_out or 8,
        border_size = vars.border_size or 2,
        col = {
            active_border = { colors = { colors.active_border_1, colors.active_border_2 }, angle = 45 },
            inactive_border = colors.inactive_border,
        },
        layout = vars.window_layout or "dwindle",
        allow_tearing = false,
        resize_on_border = true,
    },
    input = {
        kb_layout = vars.kb_layout or "us,ru,ua",
        kb_variant = vars.kb_variant or "",
        kb_options = vars.kb_options or "grp:alt_shift_toggle",
        follow_mouse = 1,

        -- Centralized Mouse Sensitivity & Acceleration Profile
        sensitivity = vars.mouse_sensitivity or -0.7,
        accel_profile = vars.accel_profile or "adaptive",

        touchpad = {
            natural_scroll = vars.natural_scroll ~= false,
            disable_while_typing = true,
            tap_to_click = true,
        },
    },
    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
        vrr = 1,
        focus_on_activate = false,
        initial_workspace_tracking = vars.initial_workspace_tracking or 1,
    },
    dwindle = {
        force_split = vars.dwindle_split_direction or 0,
        smart_split = vars.dwindle_smart_split or false,
        preserve_split = vars.dwindle_preserve_split ~= false,
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
