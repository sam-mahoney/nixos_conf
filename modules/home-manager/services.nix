{ config, pkgs, ... }:

{
  # === Polkit Authentication Agent ===
  # Required for GUI privilege escalation prompts
  # Launched as a systemd user service under Sway
  systemd.user.services.polkit-gnome-agent = {
    Unit = {
      Description = "GNOME Polkit Authentication Agent";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
