-- Decoration configuration (Blur, Rounding, Shadow)
-- Dynamically parameterized via vars.lua
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#decoration

local vars = require("vars")

hl.config({
    decoration = {
        rounding = vars.rounding or 10,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 0.95,

        blur = {
            enabled = true,
            size = 5,
            passes = 2,
            vibrancy = 0.1696,
        },

        shadow = {
            enabled = true,
            range = 10,
            render_power = 3,
            color = 0x55000000,
        },
    },
})
