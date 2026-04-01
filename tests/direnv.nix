let
  flake = builtins.getFlake (toString ../.);
  heliosDirenv = flake.nixosConfigurations.helios.config.home-manager.users.mahoney.programs.direnv;
in
assert heliosDirenv.enable;
assert heliosDirenv.nix-direnv.enable;
true
