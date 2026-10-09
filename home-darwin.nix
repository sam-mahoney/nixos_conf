{ lib, pkgs, theme, ... }:

let
  wallpaper = import ./modules/wallpaper.nix { inherit pkgs lib theme; };
in
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

  # Set the lutgen-recoloured wallpaper on every screen. desktoppr uses NSWorkspace,
  # so no Automation permission prompt like an osascript approach would need.
  home.activation.wallpaper = lib.mkIf (wallpaper != null) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${pkgs.desktoppr}/bin/desktoppr ${wallpaper}
    ''
  );
}
