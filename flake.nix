{
  description = "Helios NixOS Flake";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixos-hardware, ...}@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations.helios = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
	  nixos-hardware.nixosModules.dell-precision-5570
	  ./configuration.nix
        ];
    };
  };
}
