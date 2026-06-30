{ ... }:

{
  imports = [
    ./modules/home-manager/common.nix
    ./modules/home-manager/aerospace.nix
  ];

  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  programs.home-manager.enable = true;

  targets.darwin.copyApps.enable = false;

  fonts.fontconfig.enable = true;
}
