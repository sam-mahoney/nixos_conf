{ config, pkgs, ... }:

# === Shared NixOS System Configuration ===
# Common modules and settings reused by all hosts.

{
  imports = [
    # === Modular Configuration ===
    # System configuration split into logical modules
    ./boot.nix # Bootloader and disk encryption
    ./networking.nix # Network configuration
    ./locale.nix # Timezone and language settings
    ./desktop.nix # Desktop environment and display manager
    ./hardware.nix # Audio, printing, and input devices
    ./users.nix # User accounts and groups
    ./packages.nix # System-wide packages and fonts
    ./services.nix # System services (SSH, etc.)
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

  # === Nix Store Cleanup ===
  # Weekly GC keeping the last 3 system generations, plus hard-link dedup of the store.
  # nix-collect-garbage only prunes by age, so trim the system profile by count first.
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
  systemd.services.nix-gc.preStart = ''
    ${config.nix.package}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +3
  '';
  nix.optimise.automatic = true;

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
