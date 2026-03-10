{
  # === NixOS Flake Configuration ===
  # Declarative system configuration using Nix Flakes
  # 
  # This flake defines the Helios and Apollo system configurations with:
  #   - NixOS system configuration
  #   - Home Manager for user-level configuration
  #   - Hardware-specific optimizations for Dell Precision 5570
  #
  # Build and activate with:
  #   sudo nixos-rebuild switch --flake .#helios
  #
  # Update all inputs:
  #   nix flake update
  #
  # For more information:
  #   - Flakes: https://wiki.nixos.org/wiki/Flakes
  #   - NixOS: https://nixos.org/manual/nixos/stable/
  
  description = "Helios NixOS Flake";
  
  # === Inputs ===
  # External dependencies for this flake
  inputs = {
    # NixOS 25.11 stable channel
    # Primary source for system packages and modules
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    
    # Hardware-specific configuration repository
    # Provides optimized settings for various laptop models
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    
    # Home Manager for user-level configuration
    # Manages dotfiles, user packages, and user services
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # Ensure home-manager uses the same nixpkgs as the system
      # This prevents version mismatches and reduces disk usage
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia — minimal desktop shell for Wayland (replaces waybar)
    # Requires its own Quickshell fork (noctalia-qs)
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Peon Ping — AI agent sound/notification hooks
    peon-ping = {
      url = "github:PeonPing/peon-ping";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # === Outputs ===
  # What this flake produces (system configurations)
  outputs = { self, nixpkgs, nixos-hardware, home-manager, ...}@inputs:
    let
      # Target system architecture
      system = "x86_64-linux";

      # Import nixpkgs for the specified system
      pkgs = import nixpkgs { inherit system; };

      mkHost = { configPath, extraModules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules =
            extraModules
            ++ [
              configPath
              home-manager.nixosModules.home-manager
              {
                # Use system-level nixpkgs for home-manager
                # Reduces closures and ensures consistency
                home-manager.useGlobalPkgs = true;

                # Install packages to /etc/profiles instead of ~/.nix-profile
                # Allows better integration with NixOS
                home-manager.useUserPackages = true;

                # User-specific home-manager configuration
                # Imports all home-manager modules from ./modules/home-manager/
                home-manager.users.mahoney = import ./home.nix;

                # Pass flake inputs to home-manager modules (needed for noctalia)
                home-manager.extraSpecialArgs = { inherit inputs; };
              }
            ];
        };
    in
    {
      checks.${system}.secret-scan = pkgs.runCommand "secret-scan" {
        nativeBuildInputs = [ pkgs.gitleaks ];
      } ''
        export HOME="$TMPDIR"
        cd ${self}
        gitleaks detect \
          --source . \
          --no-git \
          --redact \
          --exit-code 1
        touch "$out"
      '';

      # === NixOS Configuration: helios ===
      # Main system configuration for the Helios laptop
      nixosConfigurations.helios = mkHost {
        configPath = ./configuration.nix;
        extraModules = [
          # Hardware-specific optimizations for Dell Precision 5570
          nixos-hardware.nixosModules.dell-precision-5570
        ];
      };

      # === NixOS Configuration: apollo ===
      # Main system configuration for the Apollo desktop
      nixosConfigurations.apollo = mkHost {
        configPath = ./configuration-apollo.nix;
      };
    };
}
