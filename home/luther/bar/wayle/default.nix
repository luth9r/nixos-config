{ pkgs, vars, lib, ... }:

let
  rightModules =
    if vars.isLaptop or false then
      ''["keyboard-input", "bluetooth", "network", "volume", "battery", "hyprsunset", "notifications", "dashboard"]''
    else
      ''["keyboard-input", "bluetooth", "network", "volume", "hyprsunset", "notifications", "dashboard"]'';

  configuredConfig = pkgs.replaceVars ./config/config.toml {
    font = vars.font;
    colorBg = vars.colorBg;
    colorSurface = vars.colorSurface;
    colorBgAlt = vars.colorBgAlt;
    colorFg = vars.colorFg;
    colorFgMuted = vars.colorFgMuted;
    colorAccent = vars.colorAccent;
    colorWarning = vars.colorWarning;
    colorBorderActive2 = vars.colorBorderActive2;
    rightModules = rightModules;
  };
in
{
  home.packages = with pkgs; [
    wayle
    brightnessctl
    wireplumber
    networkmanager
    bluez
    blueman
  ];

  # Symlink Wayle configuration generated dynamically from vars.nix
  xdg.configFile."wayle/config.toml".source = configuredConfig;
}
