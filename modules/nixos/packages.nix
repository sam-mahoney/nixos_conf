{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim # Available before home-manager activates; useful for emergency recovery
    wget
    git
    inotify-tools
    wireguard-tools
    polkit_gnome
    brightnessctl
  ];

  environment.shellAliases = {
    vpn-up = "wg-quick up wg0";
    vpn-down = "wg-quick down wg0";
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    font-awesome
  ];
}
