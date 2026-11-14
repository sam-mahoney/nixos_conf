{ config, ... }:

# Apollo: AMD 9950X + RTX 5080 desktop.

{
  imports = [
    ./hardware.nix
    ./gaming.nix
    ../../modules/nixos
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
