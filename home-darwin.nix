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

  targets.darwin.linkApps.enable = true;
  targets.darwin.linkApps.directory = "Applications/Home Manager Apps";
  targets.darwin.copyApps.enable = false;

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  fonts.fontconfig.enable = true;

  home.stateVersion = "25.11";
}
