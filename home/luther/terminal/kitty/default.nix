{ pkgs, vars, ... }:

let
  configuredConfig = pkgs.replaceVars ./kitty.conf {
    font = vars.font;
    fontSize = toString vars.fontSize;
  };

  configuredColors = pkgs.replaceVars ./colors.conf {
    colorFg = vars.colorFg;
    colorBg = vars.colorBg;
    colorAccentFg = vars.colorAccentFg;
    colorAccent = vars.colorAccent;
    colorSurface = vars.colorSurface;
    colorBorder = vars.colorBorder;
    colorRed = vars.colorRed;
    colorGreen = vars.colorGreen;
    colorYellow = vars.colorYellow;
    colorBlue = vars.colorBlue;
    colorMagenta = vars.colorMagenta;
    colorCyan = vars.colorCyan;
  };
in
{
  home.packages = with pkgs; [
    kitty
  ];

  # Link configuration files into ~/.config/kitty
  xdg.configFile."kitty/kitty.conf".source = configuredConfig;
  xdg.configFile."kitty/colors.conf".source = configuredColors;
}
