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

  description = "Mahoney mixed NixOS and Darwin flake";

  # === Inputs ===
  # External dependencies for this flake
  inputs = {
    # NixOS 25.11 stable channel
    # Primary source for system packages and modules
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Hardware-specific configuration repository
    # Provides optimized settings for various laptop models
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Secondary nixpkgs channel used only for fast-moving packages
    # Keep system on stable while allowing targeted package overrides
    nixpkgs-opencode.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager for user-level configuration
    # Manages dotfiles, user packages, and user services
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # Ensure home-manager uses the same nixpkgs as the system
      # This prevents version mismatches and reduces disk usage
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
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

    caveman = {
      url = "github:JuliusBrussee/caveman";
      flake = false;
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # mac-app-util — trampoline .app bundles so Spotlight can index Nix apps
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  # === Outputs ===
  # What this flake produces (system configurations)
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-opencode,
      nixos-hardware,
      home-manager,
      darwin,
      mac-app-util,
      ...
    }@inputs:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      pkgs = mkPkgs linuxSystem;

      opencodeOverlay =
        final: prev:
        let
          pkgsOpencode = import nixpkgs-opencode {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        in
        {
          opencode = pkgsOpencode.opencode;
        };

      darwinBuildFixesOverlay = final: prev: {
        direnv = prev.direnv.overrideAttrs (_: {
          doCheck = false;
        });
      };

      mkLinuxHost =
        {
          configPath,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          specialArgs = { inherit inputs; };
          modules = extraModules ++ [
            configPath
            home-manager.nixosModules.home-manager
            {
              # Override opencode from nixos-unstable while keeping stable base
              nixpkgs.overlays = [
                opencodeOverlay
                darwinBuildFixesOverlay
              ];

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

      mkDarwinHost =
        { hostModule, homeModule }:
        darwin.lib.darwinSystem {
          system = darwinSystem;
          specialArgs = { inherit inputs; };
          modules = [
            hostModule
            home-manager.darwinModules.home-manager
            mac-app-util.darwinModules.default
            {
              nixpkgs.overlays = [
                opencodeOverlay
                darwinBuildFixesOverlay
              ];
              nixpkgs.config.allowUnfree = true;
              nixpkgs.config.allowUnfreePredicate =
                pkg:
                builtins.elem (nixpkgs.lib.getName pkg) [
                  "onepassword-password-manager"
                ];

              users.users.mahoney = {
                name = "mahoney";
                home = "/Users/mahoney";
              };

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-backup";
              home-manager.users.mahoney = import homeModule;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
            }
          ];
        };
    in
    {
      checks.${linuxSystem}.secret-scan =
        pkgs.runCommand "secret-scan"
          {
            nativeBuildInputs = [ pkgs.gitleaks ];
          }
          ''
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
      nixosConfigurations.helios = mkLinuxHost {
        configPath = ./configuration.nix;
        extraModules = [
          # Hardware-specific optimizations for Dell Precision 5570
          nixos-hardware.nixosModules.dell-precision-5570
        ];
      };

      # === NixOS Configuration: apollo ===
      # Main system configuration for the Apollo desktop
      nixosConfigurations.apollo = mkLinuxHost {
        configPath = ./configuration-apollo.nix;
      };

      darwinConfigurations.halcyon = mkDarwinHost {
        hostModule = ./modules/darwin/hosts/halcyon.nix;
        homeModule = ./home-darwin.nix;
      };
    };
}
