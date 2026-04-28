{ config, pkgs, ... }:

{
  # === User Account Configuration ===
  # Define system users and their properties
  
  # Zsh must be enabled at the system level to be used as a login shell
  programs.zsh.enable = true;

  users.users.mahoney = {
    isNormalUser = true;  # Standard user account (not system account)
    description = "legend";
    shell = pkgs.zsh;     # Zsh as default login shell
    
    # === Group Membership ===
    # Groups grant permissions and capabilities
    extraGroups = [
      "networkmanager"  # Manage network connections without sudo
      "wheel"           # Can use sudo for administrative tasks
      "docker"          # Run Docker commands without sudo
      "video"           # Backlight control via brightnessctl
    ];
    
    # === User-Specific Packages ===
    packages = with pkgs; [
      # Packages installed only for this user (currently none)
      # Prefer home-manager for user packages
    ];
  };
}
