{ pkgs, osConfig, ... }:

let
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  # The system's SwayFX build, so stock sway isn't pulled in just for swaymsg
  swaymsg = "${osConfig.programs.sway.package}/bin/swaymsg";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  pgrep = "${pkgs.procps}/bin/pgrep";
in
{
  services.swayidle = {
    enable = true;
    systemdTargets = [ "sway-session.target" ];

    timeouts = [
      # Already locked (e.g. Alt+Escape): don't wait for the full idle timeout
      # to blank the displays. Does nothing while the session is unlocked.
      {
        timeout = 30;
        command = "${pgrep} -x swaylock >/dev/null && ${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
      {
        timeout = 120;
        command = "${brightnessctl} set 10%";
        resumeCommand = "${brightnessctl} set 50%";
      }
      {
        timeout = 300;
        command = "${swaylock} -f";
      }
      {
        timeout = 360;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
      {
        timeout = 600;
        command = "${systemctl} suspend";
      }
    ];

    events = {
      before-sleep = "${swaylock} -f";
    };
  };
}
