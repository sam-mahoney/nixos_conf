{ config, pkgs, ... }:

{
  # Hostname is set per host in ./modules/nixos/hosts/*.nix
  networking.networkmanager.enable = true;
}
