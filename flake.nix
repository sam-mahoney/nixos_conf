{
  description = "Mahoney mixed NixOS and Darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Secondary nixpkgs channel for fast-moving or broken-in-stable packages.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caveman = {
      url = "github:JuliusBrussee/caveman";
      flake = false;
    };

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      darwin,
      mac-app-util,
      ...
    }@inputs:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";

      user = "mahoney";
      theme = import ./modules/theme.nix;

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      pkgs = mkPkgs linuxSystem;

      unstableOverlay =
        final: prev:
        let
          pkgsUnstable = import nixpkgs-unstable {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        in
        {
          opencode = pkgsUnstable.opencode;
          ollama = pkgsUnstable.ollama;
        };

      darwinBuildFixesOverlay = final: prev: {
        direnv = prev.direnv.overrideAttrs (_: {
          doCheck = false;
        });
      };

      hmSpecialArgs = { inherit inputs user theme; };

      hmCommon = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.extraSpecialArgs = hmSpecialArgs;
      };

      mkLinuxHost =
        {
          hostModule,
          homeModule ? ./home.nix,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          specialArgs = { inherit inputs user theme; };
          modules = extraModules ++ [
            hostModule
            home-manager.nixosModules.home-manager
            hmCommon
            {
              nixpkgs.overlays = [ unstableOverlay ];
              home-manager.users.${user} = import homeModule;
            }
          ];
        };

      mkDarwinHost =
        { hostModule, homeModule }:
        darwin.lib.darwinSystem {
          system = darwinSystem;
          specialArgs = { inherit inputs user theme; };
          modules = [
            hostModule
            home-manager.darwinModules.home-manager
            mac-app-util.darwinModules.default
            hmCommon
            {
              nixpkgs.overlays = [
                unstableOverlay
                darwinBuildFixesOverlay
              ];
              nixpkgs.config.allowUnfreePredicate =
                pkg:
                builtins.elem (nixpkgs.lib.getName pkg) [
                  "onepassword-password-manager"
                ];

              users.users.${user} = {
                name = user;
                home = "/Users/${user}";
              };

              home-manager.users.${user} = import homeModule;
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

      nixosConfigurations.helios = mkLinuxHost {
        hostModule = ./configuration.nix;
        extraModules = [
          nixos-hardware.nixosModules.dell-precision-5570
        ];
      };

      nixosConfigurations.apollo = mkLinuxHost {
        hostModule = ./configuration-apollo.nix;
      };

      darwinConfigurations.halcyon = mkDarwinHost {
        hostModule = ./modules/darwin/hosts/halcyon.nix;
        homeModule = ./home-darwin.nix;
      };
    };
}
