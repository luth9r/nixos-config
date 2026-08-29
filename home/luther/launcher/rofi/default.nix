{ pkgs, vars, ... }:

let
  configuredColors = pkgs.replaceVars ./colors.rasi {
    bg = vars.colorBg;
    bgAlt = vars.colorBgAlt;
    fg = vars.colorFg;
    fgDim = vars.colorFgMuted;
    accent = vars.colorAccent;
    borderCol = vars.colorBorderActive1;
  };
in
{
  home.packages = with pkgs; [
    rofi
  ];

  # Link configuration and colors into ~/.config/rofi
  xdg.configFile."rofi/config.rasi".source = ./config.rasi;
  xdg.configFile."rofi/colors.rasi".source = configuredColors;
  xdg.configFile."rofi/wallpaper.rasi".source = ./wallpaper.rasi;
  xdg.configFile."rofi/window.rasi".source = ./window.rasi;
}
