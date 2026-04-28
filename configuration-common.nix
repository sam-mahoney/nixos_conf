{ config, pkgs, ... }:

# === Shared NixOS System Configuration ===
# Common modules and settings reused by all hosts.

{
  imports = [
    # === Modular Configuration ===
    # System configuration split into logical modules
    ./modules/nixos/boot.nix # Bootloader and disk encryption
    ./modules/nixos/networking.nix # Network configuration
    ./modules/nixos/locale.nix # Timezone and language settings
    ./modules/nixos/desktop.nix # Desktop environment and display manager
    ./modules/nixos/hardware.nix # Audio, printing, and input devices
    ./modules/nixos/users.nix # User accounts and groups
    ./modules/nixos/packages.nix # System-wide packages and fonts
    ./modules/nixos/services.nix # System services (SSH, etc.)
  ];

  # === Nix Configuration ===
  # Enable experimental features for flakes and new CLI
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    download-buffer-size = 256 * 1024 * 1024; # 256 MiB
  };

  # === Foreign Binary Compatibility ===
  # Allow selected upstream Linux binaries to run on NixOS.
  # Needed for tools like Steampipe that download their own embedded runtime.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
    ];
  };

  # === NixOS Version ===
  # This value determines the NixOS release from which default settings
  # for stateful data (file locations, database versions) were taken.
  #
  # DO NOT CHANGE this value after installation without consulting the
  # release notes, as it may cause compatibility issues.
  # https://nixos.org/manual/nixos/stable/release-notes
  system.stateVersion = "25.11";
}
