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

  # === TeamViewer ===
  # Remote desktop and support software
  # TODO: Remove this after IT department setup is complete
  services.teamviewer.enable = true;

  # === Firewall Configuration ===
  # Uncomment to open specific ports:
  # networking.firewall.allowedTCPPorts = [ 80 443 ];
  # networking.firewall.allowedUDPPorts = [ 53 ];
  
  # Or disable firewall entirely (not recommended):
  # networking.firewall.enable = false;
}
