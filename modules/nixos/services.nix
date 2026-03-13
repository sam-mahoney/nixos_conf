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
  services.teamviewer.enable = false;

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

  # === Power Management ===
  # TLP - Advanced power management for Linux laptops
  # Optimizes battery life and reduces heat/fan noise
  # https://wiki.nixos.org/wiki/Laptop
  
  services.tlp = {
    enable = true;
    
    settings = {
      # CPU Performance
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";       # Balanced frequency scaling on AC
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";      # Battery saving when on battery

      # CPU Energy/Performance Policy (HWP.EPP)
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";  # Reduce high-frequency spikes/noise
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";               # Prefer power saving on battery

      # Limit AC max performance slightly to reduce VRM/coil noise
      CPU_MIN_PERF_ON_AC = 5;
      CPU_MAX_PERF_ON_AC = 90;

      # CPU Boost
      CPU_BOOST_ON_AC = 1;      # Keep turbo available for burst workloads
      CPU_BOOST_ON_BAT = 0;     # Disable turbo boost on battery (saves power)

      # Platform Profile (if supported)
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Disable dynamic HWP boost to reduce rapid frequency swings
      CPU_HWP_DYN_BOOST_ON_AC = 0;
      
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

  # === UPower ===
  # D-Bus service for power device information (battery, AC adapter)
  # Required by Noctalia shell for battery widget
  services.upower.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # === Firewall Configuration ===
  # Uncomment to open specific ports:
  # networking.firewall.allowedTCPPorts = [ 80 443 ];
  # networking.firewall.allowedUDPPorts = [ 53 ];
  
  # Or disable firewall entirely (not recommended):
  # networking.firewall.enable = false;
}
