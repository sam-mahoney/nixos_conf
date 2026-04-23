{ ... }:

{
  services.swayidle = {
    enable = true;
    systemdTarget = "sway-session.target";

    timeouts = [
      {
        timeout = 120;
        command = "brightnessctl set 10%";
        resumeCommand = "brightnessctl set 50%";
      }
      {
        timeout = 300;
        command = "swaylock -f";
      }
      {
        timeout = 360;
        command = "swaymsg 'output * power off'";
        resumeCommand = "swaymsg 'output * power on'";
      }
      {
        timeout = 600;
        command = "systemctl suspend";
      }
    ];

    events = [
      {
        event = "before-sleep";
        command = "swaylock -f";
      }
    ];
  };
}
