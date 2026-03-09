{ config, pkgs, ... }:

{
  # === Bootloader Configuration ===
  # Using systemd-boot (formerly gummiboot) as the UEFI boot manager
  # https://wiki.nixos.org/wiki/Bootloader
  
  boot.loader.systemd-boot.enable = true;
  
  # Allow modifying EFI variables (required for boot entry management)
  boot.loader.efi.canTouchEfiVariables = true;

  # === Kernel Parameters ===
  # Suppress verbose boot messages so the greeter starts on a clean screen
  # Remove "quiet" temporarily if you need to debug boot issues
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
    # Prefer stable i915 over experimental xe on Alder Lake iGPU
    "i915.force_probe=46a6"
    "xe.force_probe=!46a6"
  ];

  # Known wake-up instability on this platform is often linked to spd5118 resume.
  # Blacklist it until upstream resume handling is consistently stable.
  boot.blacklistedKernelModules = [ "spd5118" ];

  # Hide the systemd-boot menu unless you hold a key
  # Speeds up boot and keeps things clean
  boot.loader.timeout = 0;

  # === LUKS Disk Encryption ===
  # Full disk encryption using dm-crypt/LUKS
  # Automatically unlocks encrypted root partition during boot
  boot.initrd.luks.devices."luks-ffeb8c8b-0b47-4b51-9d3a-d21ca17e832a".device = 
    "/dev/disk/by-uuid/ffeb8c8b-0b47-4b51-9d3a-d21ca17e832a";
}
