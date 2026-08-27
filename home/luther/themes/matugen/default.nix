{ pkgs, ... }:

{
  home.packages = with pkgs; [
    matugen
  ];

  # Link Matugen configuration and templates into ~/.config/matugen
  xdg.configFile."matugen/config.toml".source = ./config.toml;
  xdg.configFile."matugen/templates/colors.lua".source = ./templates/colors.lua;
  xdg.configFile."matugen/templates/colors.css".source = ./templates/colors.css;
  xdg.configFile."matugen/templates/colors.conf".source = ./templates/colors.conf;
  xdg.configFile."matugen/templates/colors.rasi".source = ./templates/colors.rasi;
  xdg.configFile."matugen/templates/wayle.toml".source = ./templates/wayle.toml;
}
