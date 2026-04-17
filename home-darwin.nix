{ pkgs, inputs, ... }:

{
  home.username = "mahoney";
  home.homeDirectory = "/Users/mahoney";

  imports = [
    ./modules/home-manager/common.nix
    ./modules/home-manager/aerospace.nix
  ];

  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  targets.darwin.copyApps.enable = false;

  fonts.fontconfig.enable = true;

  home.stateVersion = "25.11";
}
