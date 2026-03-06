{ ... }:

# === NixOS System Configuration: Helios ===
# Host entrypoint for the Helios laptop.

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nixos/hosts/helios.nix
    ./configuration-common.nix
  ];
}
