{
  config,
  pkgs,
  osConfig,
  ...
}:

let
  grep = "${pkgs.gnugrep}/bin/grep";
  # The system's SwayFX build, so stock sway isn't pulled in just for swaymsg
  swaymsg = "${osConfig.programs.sway.package}/bin/swaymsg";
in
{
  # The unit doesn't reference the config file, so without this a rebuild
  # that only changes profiles leaves the old kanshi running.
  systemd.user.services.kanshi.Unit.X-Restart-Triggers = [
    "${config.xdg.configFile."kanshi/config".source}"
  ];

  services.kanshi = {
    enable = true;
    systemdTarget = "sway-session.target";
    settings = [
      {
        profile.name = "laptop";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1200@59.950Hz";
            position = "0,0";
          }
        ];
      }
      {
        profile.name = "docked";
        # kanshi can't match on lid state, so the profile always enables eDP-1
        # and this turns it back off if the lid is shut when the profile applies.
        # sway's bindswitch handles the lid moving after that.
        profile.exec = [
          "${grep} -q closed /proc/acpi/button/lid/*/state && ${swaymsg} output eDP-1 disable"
        ];
        profile.outputs = [
          {
            criteria = "Dell Inc. DELL U2723QE 9P79FH3";
            status = "enable";
            mode = "3840x2160@59.997Hz";
            position = "0,0";
          }
          {
            criteria = "ASUSTek COMPUTER INC PG27UCDM W2LMAS000406";
            status = "enable";
            mode = "3840x2160@120.000Hz";
            position = "3840,0";
          }
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1200@59.950Hz";
            position = "4800,2160";
          }
        ];
      }
    ];
  };
}
