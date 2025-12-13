{ config, pkgs, ... }:

{
  # === Bootloader Configuration ===
  # Using systemd-boot (formerly gummiboot) as the UEFI boot manager
  # https://wiki.nixos.org/wiki/Bootloader
  
  boot.loader.systemd-boot.enable = true;
  
  # Allow modifying EFI variables (required for boot entry management)
  boot.loader.efi.canTouchEfiVariables = true;

  # === LUKS Disk Encryption ===
  # Full disk encryption using dm-crypt/LUKS
  # Automatically unlocks encrypted root partition during boot
  boot.initrd.luks.devices."luks-ffeb8c8b-0b47-4b51-9d3a-d21ca17e832a".device = 
    "/dev/disk/by-uuid/ffeb8c8b-0b47-4b51-9d3a-d21ca17e832a";
}
