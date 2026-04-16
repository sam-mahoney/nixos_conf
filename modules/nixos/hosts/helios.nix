{
  config,
  lib,
  inputs,
  ...
}:

{
  networking.hostName = "helios";

  # The nixos-hardware Precision 5570 module prefers xe for device 46a6.
  # Override so helios keeps the stable i915 path for external displays.
  disabledModules = [ "${inputs.nixos-hardware}/dell/precision/5570" ];

  imports = [
    (
      { ... }:
      {
        boot.kernelParams = [
          "i915.force_probe=46a6"
          "xe.force_probe=!46a6"
          # Stabilise Intel Bluetooth controller (8087:0033) during firmware handoff
          "btusb.reset=0"
        ];
      }
    )
  ];

  # spd5118 causes wake-up instability on this platform
  boot.blacklistedKernelModules = [ "spd5118" ];

  # LUKS encrypted swap (helios-specific)
  boot.initrd.luks.devices."luks-ffeb8c8b-0b47-4b51-9d3a-d21ca17e832a".device =
    "/dev/disk/by-uuid/ffeb8c8b-0b47-4b51-9d3a-d21ca17e832a";

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
