{ pkgs, vars, ... }:

{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = vars.name;
          email = vars.email;
        };
        init = {
          defaultBranch = "main";
        };
      };
    };
    fzf.enable = true;
    zoxide.enable = true;
    bat.enable = true;
    eza.enable = true;
    btop = {
      enable = true;
      settings = {
        color_theme = "Default";
        theme_background = false;
        vim_keys = true;
      };
    };
  };

  home.packages = with pkgs; [
    python3
    fastfetch
    ripgrep
    fd
    jq
    socat
    ffmpeg
    imagemagick
    lazygit
    kdePackages.dolphin
    kdePackages.kio-extras
    kdePackages.kio-admin
    kdePackages.kdegraphics-thumbnailers
    kdePackages.ffmpegthumbs
    kdePackages.ark
    p7zip
    unrar
    zip
    zstd
    poppler
    zed-editor
    chafa
    dust
  ];

  xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;
  xdg.configFile."fastfetch/logo.txt".source = ./fastfetch/logo.txt;
}
