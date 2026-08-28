{ pkgs, vars, lib, ... }:

let
  hexToRgb = hex:
    let
      clean = lib.strings.removePrefix "#" hex;
      r = toString (lib.trivial.fromHexString (builtins.substring 0 2 clean));
      g = toString (lib.trivial.fromHexString (builtins.substring 2 2 clean));
      b = toString (lib.trivial.fromHexString (builtins.substring 4 2 clean));
    in
      "${r}, ${g}, ${b}";

  configuredColors = pkgs.replaceVars ./lua/colors.lua {
    colorBgRgb = hexToRgb vars.colorBg;
    colorFgRgb = hexToRgb vars.colorFg;
    colorBorderActive1Rgb = hexToRgb vars.colorBorderActive1;
    colorBorderActive2Rgb = hexToRgb vars.colorBorderActive2;
    colorBorderRgb = hexToRgb vars.colorBorder;
    colorAccentRgb = hexToRgb vars.colorAccent;
  };

  configuredHyprlock = pkgs.replaceVars ./hyprlock.conf {
    font = vars.font;
    colorFgRgb = hexToRgb vars.colorFg;
    colorFgMutedRgb = hexToRgb vars.colorFgMuted;
    colorFgMutedHex = lib.strings.removePrefix "#" vars.colorFgMuted;
    colorSurfaceRgb = hexToRgb vars.colorSurface;
    colorBorderActive1Rgb = hexToRgb vars.colorBorderActive1;
    colorBorderActive2Rgb = hexToRgb vars.colorBorderActive2;
    colorWarningRgb = hexToRgb vars.colorWarning;
  };

  configuredAutostart = pkgs.replaceVars ./lua/autostart.lua {
    polkitAgent = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
    portalDaemon = "${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal";
  };
in
{
  home.packages = with pkgs; [
    hyprpaper
    awww
    hyprlock
    hypridle
    grim
    slurp
    swappy
    wl-clipboard
    cliphist
    pamixer
    brightnessctl
    hyprsunset
  ];

  # Centralized dynamic Lua variables generated directly from vars.nix
  xdg.configFile."hypr/vars.lua".text = ''
    -- Dynamically generated from vars.nix by Nix / Home Manager
    local vars = {
        max_workspaces = ${toString vars.maxWorkspaces},
        mouse_sensitivity = ${toString vars.mouseSensitivity},
        accel_profile = "${vars.accelProfile}",
        natural_scroll = ${if vars.naturalScroll then "true" else "false"},
        kb_layout = "${vars.kbLayout}",
        kb_variant = "${vars.kbVariant}",
        kb_options = "${vars.kbOptions}",
        window_layout = "${vars.windowLayout}",
        dwindle_split_direction = ${toString vars.dwindleSplitDirection},
        dwindle_smart_split = ${if vars.dwindleSmartSplit then "true" else "false"},
        dwindle_preserve_split = ${if vars.dwindlePreserveSplit then "true" else "false"},
        initial_workspace_tracking = ${toString vars.initialWorkspaceTracking},
        rounding = ${toString vars.rounding},
        border_size = ${toString vars.borderSize},
        gaps_in = ${toString vars.gapsIn},
        gaps_out = ${toString vars.gapsOut},
        font = "${vars.font}",
        font_size = ${toString vars.fontSize},
        terminal = "${vars.terminal}",
        file_manager = "${vars.fileManager}",
        browser = "${vars.browser}",
        editor = "${vars.editor}",
    }
    return vars
  '';

  # Symlink Hyprland Lua configurations into ~/.config/hypr/
  xdg.configFile."hypr/hyprland.lua".source = ./lua/init.lua;
  xdg.configFile."hypr/init.lua".source = ./lua/init.lua;
  xdg.configFile."hypr/monitors.lua".source = ./lua/monitors.lua;
  xdg.configFile."hypr/env.lua".source = ./lua/env.lua;
  xdg.configFile."hypr/general.lua".source = ./lua/general.lua;
  xdg.configFile."hypr/colors.lua".source = configuredColors;
  xdg.configFile."hypr/decoration.lua".source = ./lua/decoration.lua;
  xdg.configFile."hypr/animations.lua".source = ./lua/animations.lua;
  xdg.configFile."hypr/keybinds.lua".source = ./lua/keybinds.lua;
  xdg.configFile."hypr/rules.lua".source = ./lua/rules.lua;
  xdg.configFile."hypr/autostart.lua".source = configuredAutostart;

  # Hyprlock and Hypridle configs
  xdg.configFile."hypr/hyprlock.conf".source = configuredHyprlock;
  xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
}
