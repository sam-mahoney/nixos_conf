let
  flake = builtins.getFlake (toString ../.);
  systemConfig = flake.darwinConfigurations.halcyon.config;
  packageNames = map (
    pkg: pkg.name or (builtins.parseDrvName (toString pkg).name)
  ) systemConfig.environment.systemPackages;
in
{
  noTransmissionQt =
    !(builtins.any (name: builtins.match "transmission.*" name != null) packageNames);
}
