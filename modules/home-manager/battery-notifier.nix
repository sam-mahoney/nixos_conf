{ config, pkgs, lib, osConfig ? null, ... }:

let
  isHelios = (osConfig.networking.hostName or "") == "helios";
in
lib.mkIf isHelios {
  systemd.user.services.battery-notifier = {
    Unit = {
      Description = "Battery level notification service";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "battery-notifier" ''
        BATTERY_PATH=$(${pkgs.findutils}/bin/find /sys/class/power_supply -name 'BAT*' | ${pkgs.coreutils}/bin/head -n 1)

        if [ -z "$BATTERY_PATH" ]; then
          exit 0
        fi

        CAPACITY=$(${pkgs.coreutils}/bin/cat "$BATTERY_PATH/capacity")
        STATUS=$(${pkgs.coreutils}/bin/cat "$BATTERY_PATH/status")

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

  systemd.user.timers.battery-notifier = {
    Unit = {
      Description = "Check battery level every 2 minutes";
    };

    Timer = {
      OnBootSec = "1min";
      OnUnitActiveSec = "2min";
      Unit = "battery-notifier.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
