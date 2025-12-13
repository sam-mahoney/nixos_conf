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

  # === Power Management ===
  # TLP - Advanced power management for Linux laptops
  # Optimizes battery life and reduces heat/fan noise
  # https://wiki.nixos.org/wiki/Laptop
  
  services.tlp = {
    enable = true;
    
    settings = {
      # CPU Performance
      CPU_SCALING_GOVERNOR_ON_AC = "performance";     # Max performance when plugged in
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";      # Battery saving when on battery
      
      # CPU Energy/Performance Policy (HWP.EPP)
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";   # Prefer performance on AC
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";        # Prefer power saving on battery
      
      # CPU Boost
      CPU_BOOST_ON_AC = 1;      # Enable turbo boost when plugged in
      CPU_BOOST_ON_BAT = 0;     # Disable turbo boost on battery (saves power)
      
      # Platform Profile (if supported)
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      
      # Start/Stop charge thresholds (helps preserve battery health)
      # Prevents charging to 100% which degrades battery faster
      # Only works on some laptops (ThinkPad, etc.)
      START_CHARGE_THRESH_BAT0 = 40;  # Start charging at 40%
      STOP_CHARGE_THRESH_BAT0 = 80;   # Stop charging at 80%
      
      # USB Autosuspend
      USB_AUTOSUSPEND = 1;      # Enable USB power saving
      
      # Runtime Power Management for PCI(e) Devices
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      
      # Battery Feature Drivers (ThinkPad specific)
      NATACPI_ENABLE = 1;
      TPACPI_ENABLE = 1;
      TPSMAPI_ENABLE = 1;
    };
  };
  
  # Disable conflicting power management services
  # TLP should be the only power manager
  services.power-profiles-daemon.enable = false;

  # === Firewall Configuration ===
  # Uncomment to open specific ports:
  # networking.firewall.allowedTCPPorts = [ 80 443 ];
  # networking.firewall.allowedUDPPorts = [ 53 ];
  
  # Or disable firewall entirely (not recommended):
  # networking.firewall.enable = false;
}
