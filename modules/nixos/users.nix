{ config, pkgs, ... }:

{
  # === User Account Configuration ===
  # Define system users and their properties
  
  users.users.mahoney = {
    isNormalUser = true;  # Standard user account (not system account)
    description = "legend";
    
    # === Group Membership ===
    # Groups grant permissions and capabilities
    extraGroups = [ 
      "networkmanager"  # Manage network connections without sudo
      "wheel"           # Can use sudo for administrative tasks
      "docker"          # Run Docker commands without sudo
    ];
    
    # === User-Specific Packages ===
    packages = with pkgs; [
      # Packages installed only for this user (currently none)
      # Prefer home-manager for user packages
    ];
  };
}
