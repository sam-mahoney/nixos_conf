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
            criteria = "LG Electronics LG ULTRAFINE 412NTKF3S797";
            status = "enable";
            mode = "3840x2160@59.997Hz";
            transform = "90";
            position = "0,0";
          }
          {
            criteria = "Dell Inc. DELL U2723QE 9P79FH3";
            status = "enable";
            mode = "3840x2160@59.997Hz";
            position = "2160,0";
          }
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1200@59.950Hz";
            position = "3120,2160";
          }
        ];
      }
      {
        profile.name = "docked-closed";
        profile.outputs = [
          {
            criteria = "LG Electronics LG ULTRAFINE 412NTKF3S797";
            status = "enable";
            mode = "3840x2160@59.997Hz";
            transform = "90";
            position = "0,0";
          }
          {
            criteria = "Dell Inc. DELL U2723QE 9P79FH3";
            status = "enable";
            mode = "3840x2160@59.997Hz";
            position = "2160,0";
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
