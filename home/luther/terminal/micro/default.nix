{ pkgs, ... }:

{
  home.packages = with pkgs; [
    micro
  ];

  xdg.configFile."micro/settings.json".source = ./settings.json;
  xdg.configFile."micro/colorschemes/custom-dark.micro".source = ./colorschemes/custom-dark.micro;
}
