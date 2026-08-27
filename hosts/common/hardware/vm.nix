{ config, lib, pkgs, vars, ... }:

let
  driver = vars.gpuDriver or "hybrid-amd-nvidia";
in
{
  config = lib.mkIf (driver == "vm") {
    services.xserver.videoDrivers = [ "modesetting" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
