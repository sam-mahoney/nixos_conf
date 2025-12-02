{
  description = "Helios NixOS Flake";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # ensure nixpkgs is kept consistent throughout the flake
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ...}@inputs:
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
	  # auto deploy home-manager with `nixos-rebuild switch`
	  home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mahoney = import ./home.nix;
	    # home-manager.extraSpecialArgs to pass args to home.nix
          }
        ];
    };
  };
}
