{ pkgs, ... }:

{
  # Enable X11 Server for compatibility
  services.xserver.enable = true;

  # Enable Hyprland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Default session Hyprland
  services.displayManager.defaultSession = "hyprland";

  # Security, Polkit & PAM for Hyprlock & SDDM
  security.polkit.enable = true;
  security.pam.services.hyprlock = {};
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # GNOME Keyring Daemon for persistent session tokens, browser cookies & secrets
  services.gnome.gnome-keyring.enable = true;

  # Enable XDG Desktop Portals for Wayland screen sharing and file pickers
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Dconf for GNOME/GTK color-scheme preferences
  programs.dconf.enable = true;

  # Essential Wayland & system utilities
  environment.systemPackages = with pkgs; [
    kitty
    polkit_gnome
    wl-clipboard
    libnotify
    brightnessctl
    gsettings-desktop-schemas
    glib
    libsecret
    seahorse
  ];
}
