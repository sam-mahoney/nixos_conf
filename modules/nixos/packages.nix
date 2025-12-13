{ config, pkgs, ... }:

{
  # === System-Wide Packages ===
  # Installed for all users, available system-wide
  # For user-specific packages, use home-manager instead
  
  environment.systemPackages = with pkgs; [
    # === Essential Tools ===
    vim   # Text editor (essential for emergency recovery)
    wget  # Download files from the web
    git   # Version control system
    
    # === Networking ===
    wireguard-tools  # VPN utilities (wg, wg-quick)
    
    # === Authentication ===
    polkit_gnome  # Graphical authentication agent for privileged operations
  ];

  # === Shell Aliases ===
  # System-wide command shortcuts
  environment.shellAliases = {
    vpn-up = "wg-quick up wg0";      # Start WireGuard VPN
    vpn-down = "wg-quick down wg0";  # Stop WireGuard VPN
  };

  # === Firefox Browser ===
  # Enable Firefox with system-wide policies
  programs.firefox.enable = true;

  # === Package Configuration ===
  # Allow proprietary software (required for many drivers and apps)
  nixpkgs.config.allowUnfree = true;

  # === Font Configuration ===
  # System-wide fonts for all applications
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono  # JetBrains Mono with Nerd Font icons
    nerd-fonts.fira-code       # Fira Code with Nerd Font icons
    font-awesome               # Font Awesome icon font
  ];

  # === Home Manager ===
  # Backup file extension for home-manager conflicts
  # When home-manager would overwrite a file, it creates a backup with this extension
  home-manager.backupFileExtension = "hm-backup";
}
