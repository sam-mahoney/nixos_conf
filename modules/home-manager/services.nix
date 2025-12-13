{ config, pkgs, ... }:

{
  # === Polkit GNOME Authentication Agent ===
  # Provides graphical authentication dialogs for privileged operations
  # Required for GUI applications to request sudo/admin permissions
  
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      Wants = [ "graphical-session.target" ];  # Requires graphical session
      After = [ "graphical-session.target" ];  # Start after graphical session
    };
    
    Service = {
      Type = "simple";
      # Path to the polkit authentication agent binary
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";  # Restart if it crashes
      RestartSec = 1;          # Wait 1 second before restarting
      TimeoutStopSec = 10;     # Force kill after 10 seconds if not stopped
    };
    
    Install = {
      # Automatically start with graphical session
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
