{ config, lib, ... }:

{
  networking.hostName = "helios";

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = lib.mkForce "PCI:0:2:0";
      nvidiaBusId = lib.mkForce "PCI:1:0:0";
    };
  };
}
