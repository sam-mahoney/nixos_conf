{ config, pkgs, ... }:

{
  # Battery notification service using dunst
  # Sends notifications at critical battery levels
  
  systemd.user.services.battery-notifier = {
    Unit = {
      Description = "Battery level notification service";
      After = [ "graphical-session.target" ];
    };
    
    Service = {
      Type = "oneshot";
      # Check battery level and send notification if low
      ExecStart = pkgs.writeShellScript "battery-notifier" ''
        # Find battery path (works with BAT0, BAT1, etc.)
        BATTERY_PATH=$(find /sys/class/power_supply -name 'BAT*' | head -n 1)
        
        # Exit if no battery found (desktop systems)
        if [ -z "$BATTERY_PATH" ]; then
          exit 0
        fi
        
        # Read battery capacity and status
        CAPACITY=$(cat "$BATTERY_PATH/capacity")
        STATUS=$(cat "$BATTERY_PATH/status")
        
        # Send notifications based on battery level
        if [ "$STATUS" = "Discharging" ]; then
          if [ "$CAPACITY" -le 10 ]; then
            ${pkgs.libnotify}/bin/notify-send \
              --urgency=critical \
              --icon=battery-caution \
              "Battery Critical" \
              "Battery at $CAPACITY%. Please plug in charger!"
          elif [ "$CAPACITY" -le 20 ]; then
            ${pkgs.libnotify}/bin/notify-send \
              --urgency=normal \
              --icon=battery-low \
              "Battery Low" \
              "Battery at $CAPACITY%. Consider charging soon."
          fi
        fi
        
        # Notify when fully charged
        if [ "$STATUS" = "Full" ] || [ "$STATUS" = "Not charging" ]; then
          if [ "$CAPACITY" -ge 95 ]; then
            ${pkgs.libnotify}/bin/notify-send \
              --urgency=low \
              --icon=battery-full-charged \
              "Battery Fully Charged" \
              "Battery at $CAPACITY%. You can unplug the charger."
          fi
        fi
      '';
    };
  };
  
  # Timer to run battery check every 2 minutes
  systemd.user.timers.battery-notifier = {
    Unit = {
      Description = "Check battery level every 2 minutes";
    };
    
    Timer = {
      OnBootSec = "1min";      # First check 1 minute after boot
      OnUnitActiveSec = "2min"; # Then check every 2 minutes
      Unit = "battery-notifier.service";
    };
    
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
