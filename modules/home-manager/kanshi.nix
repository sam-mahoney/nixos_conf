{ ... }:

{
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
        profile.name = "docked-open";
        profile.exec = [ ];
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
      {
        profile.name = "docked-closed";
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
            status = "disable";
          }
        ];
        profile.exec = [ ];
      }
    ];
  };
}
