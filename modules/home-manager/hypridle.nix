{ config, pkgs, ... }:

{
  # Hypridle - Idle management daemon for Hyprland
  # Handles automatic screen locking, display timeout, and suspend
  # https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/
  
  services.hypridle = {
    enable = true;
    
    settings = {
      # === General Configuration ===
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";  # Lock screen (avoid starting if already running)
        before_sleep_cmd = "loginctl lock-session";  # Lock before system sleep
        after_sleep_cmd = "hyprctl dispatch dpms on";  # Turn screen on after wake
        ignore_dbus_inhibit = false;  # Respect apps that inhibit idle (e.g., video players)
      };
      
      # === Idle Listeners ===
      # Multiple timeouts for progressive power saving
      
      listener = [
        # --- Dim Screen (2 minutes of idle) ---
        {
          timeout = 120;  # 2 minutes
          on-timeout = "brightnessctl set 10%";  # Dim to 10%
          on-resume = "brightnessctl set 50%";   # Restore to 50%
        }
        
        # --- Lock Screen (5 minutes of idle) ---
        {
          timeout = 300;  # 5 minutes
          on-timeout = "loginctl lock-session";  # Lock the session
        }
        
        # --- Turn Off Screen (6 minutes of idle) ---
        {
          timeout = 360;  # 6 minutes
          on-timeout = "hyprctl dispatch dpms off";  # Turn off display
          on-resume = "hyprctl dispatch dpms on";    # Turn display back on
        }
      ];
    };
  };
}
