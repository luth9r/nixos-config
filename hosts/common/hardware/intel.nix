{ config, lib, pkgs, vars, ... }:

let
  driver = vars.gpuDriver or "hybrid-amd-nvidia";
in
{
  config = lib.mkIf (driver == "intel") {
    services.xserver.videoDrivers = [ "modesetting" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        vpl-gpu-rt
      ];
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.full
      mangohud
    ];
  };
}
