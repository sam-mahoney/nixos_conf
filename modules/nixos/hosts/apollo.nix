{ config, ... }:

{
  imports = [
    ./apollo-gaming.nix
  ];

  networking.hostName = "apollo";

  # Desktop GPU stack for RTX 5080
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
}
