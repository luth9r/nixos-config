{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris       # MPRIS control for playerctl & Wayle media widget
      thumbfast   # High performance thumbnail previews on seekbar
      uosc        # Clean, modern, minimalist on-screen controller
    ];
    config = {
      hwdec = "auto-safe";
      vo = "gpu-next";
      gpu-context = "wayland";
      keep-open = "yes";
      save-position-on-quit = "yes";
      osd-font = "JetBrainsMono Nerd Font";
    };
  };

  home.packages = with pkgs; [
    playerctl
    celluloid
    vlc
    loupe
    awww
    slurp
    grim
    satty
    libnotify
    ffmpeg
  ];

  # Symlink helper scripts into ~/.config/hypr/scripts/
  xdg.configFile."hypr/scripts/change-wall.sh" = {
    source = ./scripts/change-wall.sh;
    executable = true;
  };

  xdg.configFile."hypr/scripts/screenshot.sh" = {
    source = ./scripts/screenshot.sh;
    executable = true;
  };

  xdg.configFile."hypr/scripts/record.sh" = {
    source = ./scripts/record.sh;
    executable = true;
  };

  xdg.configFile."hypr/scripts/powermenu.sh" = {
    source = ./scripts/powermenu.sh;
    executable = true;
  };

  xdg.configFile."hypr/scripts/cheatsheet.sh" = {
    source = ./scripts/cheatsheet.sh;
    executable = true;
  };

  xdg.configFile."hypr/scripts/airplane-mode.sh" = {
    source = ./scripts/airplane-mode.sh;
    executable = true;
  };

  xdg.configFile."hypr/scripts/search.sh" = {
    source = ./scripts/search.sh;
    executable = true;
  };

  xdg.configFile."hypr/scripts/find-files.sh" = {
    source = ./scripts/find-files.sh;
    executable = true;
  };

  xdg.configFile."hypr/scripts/window-switcher.sh" = {
    source = ./scripts/window-switcher.sh;
    executable = true;
  };
}
