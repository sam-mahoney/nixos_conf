{ pkgs, ... }:

{
  imports = [
    ./modules/home-manager/common.nix
    ./modules/home-manager/sway.nix
    ./modules/home-manager/swayidle.nix
    ./modules/home-manager/kanshi.nix
    ./modules/home-manager/noctalia.nix
    ./modules/home-manager/services.nix
    ./modules/home-manager/swaylock.nix
    ./modules/home-manager/battery-notifier.nix
  ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 24;
  };
}
