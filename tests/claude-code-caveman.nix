let
  flake = builtins.getFlake (toString ../.);
  hm = flake.darwinConfigurations.halcyon.config.home-manager.users.mahoney;
  cfg = hm.xdg.configFile;
  names = builtins.attrNames cfg;
  hasTarget = suffix: builtins.any (name: cfg.${name}.target == suffix) names;
  packageNames = map (pkg: pkg.name or (builtins.parseDrvName (toString pkg).name)) hm.home.packages;
in
{
  hasClaudeCodePackage = builtins.any (
    name: builtins.match "claude-code(-.*)?" name != null
  ) packageNames;
  hasClaudeMd = hasTarget ".config/claude/CLAUDE.md";
}
