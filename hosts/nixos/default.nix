{ pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common
  ];

  networking.hostName = vars.hostname;

  # Host-specific system packages
  environment.systemPackages = with pkgs; [
    firefox
    zed-editor
    micro
  ];
}
