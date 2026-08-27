{ pkgs, vars, ... }:

{
  imports = [
    ./wm/hyprland
    ./bar/wayle
    ./launcher/rofi
    ./terminal/kitty
    ./terminal/micro
    ./terminal/starship
    ./media/shell/fish.nix
    ./media/shell/tools.nix
    ./themes
    ./media
  ];

  # User information parameterized from vars.nix
  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  # Enable XDG user directories & MIME application associations
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    # Default file-association handlers and context menu associations for Dolphin
    mimeApps = {
      enable = true;
      defaultApplications = {
        # Directories
        "inode/directory" = [ "org.kde.dolphin.desktop" ];

        # Text & Code
        "text/plain" = [ "dev.zed.Zed.desktop" "micro.desktop" ];
        "text/markdown" = [ "dev.zed.Zed.desktop" "micro.desktop" ];
        "application/json" = [ "dev.zed.Zed.desktop" "micro.desktop" ];
        "application/x-yaml" = [ "dev.zed.Zed.desktop" "micro.desktop" ];
        "application/x-shellscript" = [ "dev.zed.Zed.desktop" "micro.desktop" ];
        "application/xml" = [ "dev.zed.Zed.desktop" ];
        "text/html" = [ "firefox.desktop" ];

        # Images
        "image/png" = [ "org.gnome.Loupe.desktop" "io.github.celluloid_player.Celluloid.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" "io.github.celluloid_player.Celluloid.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" "io.github.celluloid_player.Celluloid.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" "io.github.celluloid_player.Celluloid.desktop" ];
        "image/svg+xml" = [ "org.gnome.Loupe.desktop" "firefox.desktop" ];

        # Video & Audio
        "video/mp4" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];
        "video/x-matroska" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];
        "video/webm" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];
        "audio/mpeg" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];
        "audio/flac" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];
        "audio/ogg" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];
        "audio/wav" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];

        # Documents & PDFs
        "application/pdf" = [ "firefox.desktop" ];

        # Archives
        "application/zip" = [ "org.kde.ark.desktop" ];
        "application/x-tar" = [ "org.kde.ark.desktop" ];
        "application/x-7z-compressed" = [ "org.kde.ark.desktop" ];
        "application/x-compressed-tar" = [ "org.kde.ark.desktop" ];
        "application/x-gzip" = [ "org.kde.ark.desktop" ];
        "application/x-bzip2" = [ "org.kde.ark.desktop" ];
        "application/x-xz" = [ "org.kde.ark.desktop" ];
        "application/x-rar" = [ "org.kde.ark.desktop" ];

        # Web Links & Terminal
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "x-scheme-handler/terminal" = [ "kitty.desktop" ];
      };

      associations.added = {
        # Text & Code
        "text/plain" = [ "dev.zed.Zed.desktop" "micro.desktop" ];
        "text/markdown" = [ "dev.zed.Zed.desktop" "micro.desktop" ];
        "application/json" = [ "dev.zed.Zed.desktop" "micro.desktop" ];
        "application/x-yaml" = [ "dev.zed.Zed.desktop" "micro.desktop" ];
        "application/x-shellscript" = [ "dev.zed.Zed.desktop" "micro.desktop" ];

        # Images
        "image/png" = [ "org.gnome.Loupe.desktop" "io.github.celluloid_player.Celluloid.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" "io.github.celluloid_player.Celluloid.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" "io.github.celluloid_player.Celluloid.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" "io.github.celluloid_player.Celluloid.desktop" ];
        "image/svg+xml" = [ "org.gnome.Loupe.desktop" "firefox.desktop" ];

        # Video & Audio
        "video/mp4" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];
        "video/x-matroska" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];
        "video/webm" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];
        "audio/mpeg" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];
        "audio/flac" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];
        "audio/ogg" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];
        "audio/wav" = [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" "vlc.desktop" ];

        # Documents & PDFs
        "application/pdf" = [ "firefox.desktop" ];

        # Archives
        "application/zip" = [ "org.kde.ark.desktop" ];
        "application/x-tar" = [ "org.kde.ark.desktop" ];
        "application/x-7z-compressed" = [ "org.kde.ark.desktop" ];
        "application/x-compressed-tar" = [ "org.kde.ark.desktop" ];
        "application/x-gzip" = [ "org.kde.ark.desktop" ];
        "application/x-bzip2" = [ "org.kde.ark.desktop" ];
        "application/x-xz" = [ "org.kde.ark.desktop" ];
        "application/x-rar" = [ "org.kde.ark.desktop" ];
      };
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Home Manager release state version
  home.stateVersion = "26.05";
}
