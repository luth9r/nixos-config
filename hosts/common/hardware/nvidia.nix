{ config, lib, pkgs, vars, ... }:

let
  driver = vars.gpuDriver or "hybrid-amd-nvidia";
  isNvidia = driver == "hybrid-amd-nvidia" || driver == "hybrid-intel-nvidia" || driver == "nvidia";
  isHybridAmd = driver == "hybrid-amd-nvidia";
  isHybridIntel = driver == "hybrid-intel-nvidia";
  isHybrid = isHybridAmd || isHybridIntel;
in
{
  config = lib.mkIf isNvidia {
    # Load NVIDIA proprietary kernel modules
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva-vdpau-driver
      ];
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = isHybrid;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = lib.mkIf isHybrid {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = lib.mkIf isHybridAmd (vars.amdgpuBusId or "PCI:6:0:0");
        intelBusId = lib.mkIf isHybridIntel (vars.intelBusId or "PCI:0:2:0");
        nvidiaBusId = vars.nvidiaBusId or "PCI:1:0:0";
      };
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.full
      mangohud

      # Universal NVIDIA GPU offload command runner
      (pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@"
      '')
    ];
  };
}
