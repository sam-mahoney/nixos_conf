{ pkgs, ... }:

{
  # === Apollo Gaming Stack ===
  # Steam for native/Proton games and Heroic for GOG library support.

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    # Steam performance/overlay tooling
    mangohud
    goverlay
    protonup-qt

    # GOG launcher and broader compatibility tooling
    heroic
    lutris

    # Gamescope CLI utility
    gamescope
  ];
}
