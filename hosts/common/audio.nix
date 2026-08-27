{ pkgs, ... }:

{
  # Sound configuration with PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Audio management utilities
  environment.systemPackages = with pkgs; [
    playerctl
    pamixer
    pavucontrol
    wireplumber
  ];
}
