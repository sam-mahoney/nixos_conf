{
  config,
  lib,
  inputs,
  ...
}:

{
  networking.hostName = "helios";

  # The nixos-hardware Precision 5570 module prefers xe for device 46a6.
  # Override the host's final kernel params so helios keeps the shared boot flags
  # while forcing the stable i915 path for external displays.
  disabledModules = [ "${inputs.nixos-hardware}/dell/precision/5570" ];

  imports = [
    (
      { ... }:
      {
        boot.kernelParams = [
          "i915.force_probe=46a6"
          "xe.force_probe=!46a6"
        ];
      }
    )
  ];

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
