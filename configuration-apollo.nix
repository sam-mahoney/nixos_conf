{ ... }:

# === NixOS System Configuration: Apollo ===
# Host entrypoint for the Apollo desktop.

{
  imports = [
    ./hardware-configuration-apollo.nix
    ./modules/nixos/hosts/apollo.nix
    ./configuration-common.nix
  ];
}
