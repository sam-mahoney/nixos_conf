{
  description = "Mahoney mixed NixOS and Darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Secondary nixpkgs channel for fast-moving or broken-in-stable packages.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pi-config = {
      url = "github:amosblomqvist/pi-config";
      flake = false;
    };

    pi-interactive-subagents = {
      url = "github:amosblomqvist/pi-interactive-subagents";
      flake = false;
    };

    pi-observational-memory = {
      url = "github:amosblomqvist/pi-observational-memory";
      flake = false;
    };

    mac-app-util.url = "github:hraban/mac-app-util";

    # Pi coding agent. Tracks the stable branch; nixpkgs is left unfollowed so
    # it builds against the toolchain upstream tested.
    pi.url = "github:earendil-works/pi/stable";

    # Live tree of systemd jobs on the boot console (NixOS module).
    bootvine = {
      url = "git+https://codeberg.org/wvhulle/bootvine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
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

      unstableOverlay =
        final: prev:
        let
          pkgsUnstable = import nixpkgs-unstable {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        in
        {
          claude-code = pkgsUnstable.claude-code;
          opencode = pkgsUnstable.opencode;
          ollama = pkgsUnstable.ollama;
          llama-cpp = pkgsUnstable.llama-cpp;
          aerospace = pkgsUnstable.aerospace;
          vscode-extensions = prev.vscode-extensions // {
            anthropic = prev.vscode-extensions.anthropic // {
              claude-code = pkgsUnstable.vscode-extensions.anthropic.claude-code;
            };
          };
        };

      piOverlay = final: prev: {
        pi-coding-agent = inputs.pi.packages.${final.stdenv.hostPlatform.system}.pi;
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

      # Each host's system config is hosts/<host>/default.nix.
      mkLinuxHost =
        host:
        nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          specialArgs = { inherit inputs user theme; };
          modules = [
            ./hosts/${host}
            home-manager.nixosModules.home-manager
            inputs.bootvine.nixosModules.default
            hmCommon
            {
              nixpkgs.overlays = [
                unstableOverlay
                piOverlay
              ];
              home-manager.users.${user} = import ./modules/home-manager/linux.nix;
            }
          ];
        };

      mkDarwinHost =
        host:
        darwin.lib.darwinSystem {
          system = darwinSystem;
          specialArgs = { inherit inputs user theme; };
          modules = [
            ./hosts/${host}
            home-manager.darwinModules.home-manager
            mac-app-util.darwinModules.default
            hmCommon
            {
              nixpkgs.overlays = [
                unstableOverlay
                piOverlay
                darwinBuildFixesOverlay
              ];

              users.users.${user} = {
                name = user;
                home = "/Users/${user}";
              };

              home-manager.users.${user} = import ./modules/home-manager/darwin.nix;
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
            }
          ];
        };
    in
    {
      # Defined for both systems so `nix flake check` scans on the Mac too.
      checks = nixpkgs.lib.genAttrs [ linuxSystem darwinSystem ] (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          secret-scan =
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
        }
      );

      nixosConfigurations.helios = mkLinuxHost "helios";
      nixosConfigurations.apollo = mkLinuxHost "apollo";

      darwinConfigurations.halcyon = mkDarwinHost "halcyon";
    };
}
