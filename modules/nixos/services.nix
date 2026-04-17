{ config, pkgs, ... }:

{
  # === OpenSSH Server ===
  # Secure shell server for remote access
  # https://wiki.nixos.org/wiki/OpenSSH
  
  services.openssh = {
    enable = true;
    
    settings = {
      # Allow X11 forwarding (run GUI apps over SSH)
      X11Forwarding = true;
      
      # Allow SSH agent forwarding (use local SSH keys on remote)
      AllowAgentForwarding = true;
      
      # Disable root login for security
      PermitRootLogin = "no";
      
      # Disable password authentication (SSH keys only)
      # SSH keys are more secure than passwords
      PasswordAuthentication = false;
    };
    
    # Open SSH port (22) in firewall
    openFirewall = true;
  };

  # === Docker ===
  # Container platform for running and managing applications
  # https://wiki.nixos.org/wiki/Docker
  
  virtualisation.docker = {
    enable = true;
    
    # Enable rootless mode for better security (optional)
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    
    # Automatically prune old containers, images, and volumes
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # === UPower ===
  # Required by Noctalia shell for battery widget
  services.upower.enable = true;

  # === Firewall Configuration ===
  # Uncomment to open specific ports:
  # networking.firewall.allowedTCPPorts = [ 80 443 ];
  # networking.firewall.allowedUDPPorts = [ 53 ];
  
  # Or disable firewall entirely (not recommended):
  # networking.firewall.enable = false;
}
