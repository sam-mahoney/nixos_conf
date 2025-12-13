{ config, pkgs, ... }:

# === Home Manager Configuration ===
# User-level configuration for the mahoney user
# Manages dotfiles, user packages, and user services
#
# This file imports modular configuration from ./modules/home-manager/
#
# After editing, rebuild with:
#   sudo nixos-rebuild switch --flake .#helios
# (home-manager is automatically deployed via flake.nix)
#
# For more information:
#   - Home Manager Manual: https://nix-community.github.io/home-manager/
#   - Home Manager Options: https://nix-community.github.io/home-manager/options.html

{
  # === User Identity ===
  home.username = "mahoney";
  home.homeDirectory = "/home/mahoney";

  # === Module Imports ===
  # User configuration split into logical modules
  imports = [
    ./modules/home-manager/packages.nix   # User packages and tools
    ./modules/home-manager/hyprland.nix   # Hyprland window manager config
    ./modules/home-manager/waybar.nix     # Status bar configuration
    ./modules/home-manager/dunst.nix      # Notification daemon config
    ./modules/home-manager/terminal.nix   # Terminal emulators and shell
    ./modules/home-manager/git.nix        # Git and SSH configuration
    ./modules/home-manager/services.nix   # User services (polkit agent)
  ];

  # === Home Manager Version ===
  # This value determines the Home Manager release corresponding to your
  # NixOS release. It ensures compatibility between home-manager and NixOS.
  #
  # DO NOT CHANGE this value without also updating system.stateVersion
  # in configuration.nix to maintain consistency.
  home.stateVersion = "25.11";
}
