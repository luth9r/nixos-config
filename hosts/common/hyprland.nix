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

  # GVFS for virtual filesystems, trash, network shares, and file-open handlers
  services.gvfs.enable = true;

  # Enable XDG Desktop Portals: Hyprland for screen capture, KDE for everything else
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    config = {
      common = {
        default = [ "kde" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
      };
      hyprland = {
        default = [ "kde" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
      };
    };
  };

  # Dconf for GNOME/GTK color-scheme preferences
  programs.dconf.enable = true;

  # Link KDE service directories for Dolphin "Open With" dialog & KIO
  environment.pathsToLink = [
    "/share/kservices6"
    "/share/kservicetypes6"
    "/share/kxmlgui6"
    "/share/kconf_update"
    "/share/qlogging-categories6"
  ];

  # Essential Wayland, KDE service & system utilities
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
    xdg-utils
    shared-mime-info
    kdePackages.kservice
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kio-admin
    kdePackages.kio-fuse
    (pkgs.writeShellScriptBin "konsole" ''
      exec ${pkgs.kitty}/bin/kitty "$@"
    '')
  ];
}
