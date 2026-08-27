-- Main Hyprland Lua Configuration Entrypoint
-- Configure package.path to correctly find all required modules in ~/.config/hypr

local home = os.getenv("HOME") or "/home/luther"
package.path = home .. "/.config/hypr/?.lua;" .. home .. "/.config/hypr/?/init.lua;" .. package.path

require("env")
require("monitors")
require("general")
require("decoration")
require("animations")
require("keybinds")
require("rules")
require("autostart")
