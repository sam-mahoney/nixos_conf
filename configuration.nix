{ config, pkgs, ... }:

# === NixOS System Configuration ===
# Main configuration file for the Helios system
# This file imports modular configuration from ./modules/nixos/
#
# After editing, rebuild the system with:
#   sudo nixos-rebuild switch --flake .#helios
#
# For more information:
#   - NixOS Manual: https://nixos.org/manual/nixos/stable/
#   - Configuration options: https://search.nixos.org/options

{
  imports = [
    # === Hardware Configuration ===
    # Auto-generated hardware-specific settings
    # Contains filesystem mounts, boot settings, kernel modules
    ./hardware-configuration.nix
    
    # === Modular Configuration ===
    # System configuration split into logical modules
    ./modules/nixos/boot.nix        # Bootloader and disk encryption
    ./modules/nixos/networking.nix  # Network configuration
    ./modules/nixos/locale.nix      # Timezone and language settings
    ./modules/nixos/desktop.nix     # Desktop environment and display manager
    ./modules/nixos/hardware.nix    # Audio, printing, and input devices
    ./modules/nixos/users.nix       # User accounts and groups
    ./modules/nixos/packages.nix    # System-wide packages and fonts
    ./modules/nixos/services.nix    # System services (SSH, etc.)
  ];

  # === Nix Configuration ===
  # Enable experimental features for flakes and new CLI
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # === NixOS Version ===
  # This value determines the NixOS release from which default settings
  # for stateful data (file locations, database versions) were taken.
  # 
  # DO NOT CHANGE this value after installation without consulting the
  # release notes, as it may cause compatibility issues.
  # https://nixos.org/manual/nixos/stable/release-notes
  system.stateVersion = "25.11";
}
