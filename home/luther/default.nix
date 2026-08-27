{ pkgs, vars, ... }:

{
  imports = [
    ./wm/hyprland
    ./bar/wayle
    ./launcher/rofi
    ./terminal/kitty
    ./terminal/micro
    ./terminal/starship
    ./shell/fish.nix
    ./shell/tools.nix
    ./themes
    ./media
  ];

  # User information parameterized from vars.nix
  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  # Enable XDG user directories
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Home Manager release state version
  home.stateVersion = "26.05";
}
