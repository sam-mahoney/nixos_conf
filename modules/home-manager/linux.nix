{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./sway.nix
    ./swayidle.nix
    ./kanshi.nix
    ./noctalia.nix
    ./services.nix
    ./swaylock.nix
    ./battery-notifier.nix
  ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.theme = config.gtk.theme;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 24;
  };
}
