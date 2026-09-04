-- Keybindings Configuration
-- Dynamically parameterized via vars.lua
-- Format: { description = "Category: Action Description" }
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local vars = require("vars")
local mainMod = "SUPER"

-- Configurable settings from vars.nix
local max_workspaces = vars.max_workspaces or 10
local terminal = vars.terminal or "kitty"
local browser = vars.browser or "firefox"
local editor = vars.editor or "code"
local file_manager = vars.file_manager or "dolphin"

-- Helper function to format readable app names dynamically
local function format_app_name(name)
    if not name or name == "" then return "" end
    if name == "code" then return "VS Code" end
    if name == "zeditor" then return "Zed" end
    return (name:gsub("^%l", string.upper))
end

-- Core Applications & Launchers
hl.bind("SUPER_L", hl.dsp.exec_cmd("rofi -show drun -show-icons"), { release = true, description = "Apps: Application launcher with search" })
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd("rofi -show drun -show-icons"), { description = "Apps: Application launcher (Rofi)" })
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("rofi -show drun -show-icons"), { description = "Apps: Application launcher (Rofi)" })
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal), { description = "Apps: Launch terminal" })
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal), { description = "Apps: Launch terminal" })
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser), { description = "Apps: Launch web browser" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(file_manager), { description = "Apps: Launch file manager" })
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(editor), { description = "Apps: Launch code editor" })
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("~/.config/hypr/scripts/window-switcher.sh"), { description = "Apps: Switch active windows by workspace (Rofi)" })
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p 'Clipboard' | cliphist decode | wl-copy"), { description = "Apps: Clipboard history manager" })
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd("~/.config/hypr/scripts/cheatsheet.sh"), { description = "Apps: Show keybindings cheatsheet" })
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/change-wall.sh"), { description = "Rice: Change wallpaper" })
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("~/.config/hypr/scripts/powermenu.sh"), { description = "System: Power & session menu" })
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(terminal .. " --class btop -e btop"), { description = "System: Launch task manager (Btop)" })
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("wayle toggle-control-center || wayle"), { description = "System: Toggle Wayle control center" })
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"), { description = "System: Lock screen (Hyprlock)" })

-- Window Management & System Control
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Window: Close active window" })
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }), { description = "Window: Toggle floating mode" })
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ action = "toggle" }), { description = "Window: Toggle fullscreen mode" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Window: Toggle pseudo tiling" })
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Window: Toggle split layout (Dwindle)" })
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload && (~/.config/hypr/scripts/cheatsheet.sh --compile &) && (pkill -x wayle; wayle shell &) && notify-send -a 'Hyprland' -i 'system-reboot' 'Hyprland Reloaded' 'Configuration reloaded successfully'"), { description = "System: Reload Hyprland configuration" })
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit(), { description = "System: Exit Hyprland session" })

-- Screenshots & Screen Recording
hl.bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh edit"), { description = "Screenshot: Capture area & open Satty editor" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh area"), { description = "Screenshot: Capture area directly to clipboard & folder" })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh full"), { description = "Screenshot: Capture entire screen directly to clipboard & folder" })
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/record.sh area"), { description = "Recording: Toggle area screen recording" })
hl.bind(mainMod .. " + SHIFT + ALT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/record.sh full"), { description = "Recording: Toggle fullscreen screen recording" })
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/record.sh area-audio"), { description = "Recording: Toggle area recording with audio" })

-- Focus Movement (Vim & Arrow keys)
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }), { description = "Navigation: Move focus left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Navigation: Move focus right" })
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }), { description = "Navigation: Move focus up" })
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }), { description = "Navigation: Move focus down" })
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "left" }), { description = "Navigation: Move focus left (Vim)" })
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "right" }), { description = "Navigation: Move focus right (Vim)" })
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "up" }), { description = "Navigation: Move focus up (Vim)" })
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "down" }), { description = "Navigation: Move focus down (Vim)" })

-- Workspaces Navigation (Super + [1..9, 0])
-- Move active window with focus (Super + Shift + [1..9, 0])
-- Throw active window to workspace silently without switching (Super + Alt + [1..9, 0])
for i = 1, max_workspaces do
    local key = i % 10
    -- Switch workspace (Super + Number)
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Workspaces: Switch to workspace " .. i })
    -- Move active window to workspace and follow focus (Super + Shift + Number)
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i), follow = true }), { description = "Workspaces: Move window to workspace " .. i .. " (follow focus)" })
    -- Throw active window to workspace silently (Super + Alt + Number)
    hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = tostring(i), follow = false }), { description = "Workspaces: Move window to workspace " .. i .. " (silent)" })
end

-- Mouse Window & Screen Management
-- Super + Mouse Wheel: Move active window forward/backward (+1 / -1)
hl.bind(mainMod .. " + mouse_up",   hl.dsp.window.move({ workspace = "+1" }), { description = "Workspaces: Move window to next workspace (+1)" })
hl.bind(mainMod .. " + mouse_down", hl.dsp.window.move({ workspace = "-1" }), { description = "Workspaces: Move window to prev workspace (-1)" })

-- Mouse Binds (Move & Resize by dragging)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "Window: Move floating window (Drag)" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Window: Resize floating window (Drag)" })

-- Multimedia, Brightness, Airplane & Fn Keys (Hyprland Official Wiki Standard)
hl.bind("XF86RFKill",           hl.dsp.exec_cmd("~/.config/hypr/scripts/airplane-mode.sh"), { locked = true, description = "System: Toggle airplane mode" })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, description = "Media: Volume up (+5%)" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true, description = "Media: Volume down (-5%)" })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, description = "Media: Toggle audio mute" })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, description = "Media: Toggle microphone mute" })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl set +5%"),       { repeating = true, description = "Media: Brightness up (+5%)" })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl set 5%-"),       { repeating = true, description = "Media: Brightness down (-5%)" })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Media: Play / Pause" })
hl.bind("XF86AudioPause",       hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Media: Play / Pause" })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),       { locked = true, description = "Media: Next track" })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),   { locked = true, description = "Media: Previous track" })
hl.bind("XF86AudioStop",        hl.dsp.exec_cmd("playerctl stop"),       { locked = true, description = "Media: Stop playback" })
