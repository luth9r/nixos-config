{ config, lib, pkgs, vars, ... }:

let
  driver = vars.gpuDriver or "hybrid-amd-nvidia";
in
{
  config = lib.mkIf (driver == "amd") {
    services.xserver.videoDrivers = [ "modesetting" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.full
      mangohud
    ];
  };
}
