{ config, pkgs, vars, ... }:

{
  # Bootloader settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Bluetooth daemon enabled, but radio adapter powered off by default on boot
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  # UPower daemon for battery percentage, health, and status queries
  services.upower.enable = true;

  # Time zone and internationalisation
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
  ];

  # Nix configuration & Automatic Maintenance
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Modern Nix Helper (nh) CLI & Generation-aware smart cleanup parameterized from vars.nix
  programs.nh = {
    enable = true;
    flake = "/home/${vars.username}/dotfiles";
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 3";
    };
  };

  # Feral GameMode (Automatic CPU/GPU Performance Tuning & Process Priority)
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send -a 'GameMode' -i 'preferences-desktop-gaming' 'Performance Mode Active' 'CPU and GPU boosted to maximum performance' 2>/dev/null || true";
        end = "${pkgs.libnotify}/bin/notify-send -a 'GameMode' -i 'preferences-desktop-gaming' 'Performance Mode Inactive' 'CPU and GPU returned to balanced power mode' 2>/dev/null || true";
      };
    };
  };

  # SSD Periodic TRIM
  services.fstrim.enable = true;

  # Power profiles daemon for Wayle / Hyprland
  services.power-profiles-daemon.enable = true;

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # Core system-wide CLI packages
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    pciutils
    usbutils
    tree
    unzip
    nvd
    nix-output-monitor
    gamemode
  ];

  # System state version
  system.stateVersion = "26.05";
}
