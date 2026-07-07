{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      AllowAgentForwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
    rootless = {
      enable = true;
      package = pkgs.docker_29;
      setSocketVariable = true;
    };
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Required by Noctalia shell for battery widget.
  services.upower.enable = true;
}
