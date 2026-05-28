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
          # Prevent NVIDIA GPU power state changes during Thunderbolt hotplug
          # (fixes hard freeze on USB-C dock disconnect)
          "nvidia.NVreg_DynamicPowerManagement=0x00"
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

  # === Power Management (laptop-specific) ===
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MIN_PERF_ON_AC = 5;
      CPU_MAX_PERF_ON_AC = 90;
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      CPU_HWP_DYN_BOOST_ON_AC = 0;
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
      USB_AUTOSUSPEND = 1;
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      RUNTIME_PM_DRIVER_DENYLIST = "nvidia";
      NATACPI_ENABLE = 1;
      TPACPI_ENABLE = 1;
      TPSMAPI_ENABLE = 1;
    };
  };
  services.power-profiles-daemon.enable = false;

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    powerManagement.enable = true;
    nvidiaPersistenced = true;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = lib.mkForce "PCI:0:2:0";
      nvidiaBusId = lib.mkForce "PCI:1:0:0";
    };
  };
}
