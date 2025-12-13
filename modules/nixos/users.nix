{ config, pkgs, ... }:

{
  # === User Account Configuration ===
  # Define system users and their properties
  
  users.users.mahoney = {
    isNormalUser = true;  # Standard user account (not system account)
    description = "mahoney";
    
    # === Group Membership ===
    # Groups grant permissions and capabilities
    extraGroups = [ 
      "networkmanager"  # Manage network connections without sudo
      "wheel"           # Can use sudo for administrative tasks
      "video"           # Access video devices and modify backlight
      "camera"          # Access camera devices
    ];
    
    # === User-Specific Packages ===
    # Packages installed only for this user (currently none)
    # Prefer home-manager for user packages
    packages = with pkgs; [
      # Example:
      # thunderbird
    ];
  };
}
