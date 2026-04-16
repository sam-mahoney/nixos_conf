let
  flake = builtins.getFlake (toString ../.);
  hm = flake.darwinConfigurations.halcyon.config.home-manager.users.mahoney;
  cfg = hm.xdg.configFile;
  names = builtins.attrNames cfg;
  hasTarget = suffix: builtins.any (name: cfg.${name}.target == suffix) names;
  packageNames = map (pkg: pkg.name or (builtins.parseDrvName (toString pkg).name)) hm.home.packages;
  inputs = builtins.attrNames flake.inputs;
in
{
  noSuperpowersInput = !(builtins.elem "superpowers" inputs);
  noDefaultSuperpowersPlugin = !hasTarget ".config/opencode/plugins/superpowers.js";
  noDefaultSuperpowersSkills = !hasTarget ".config/opencode/skills/superpowers";
  noDefaultSuperpowersTree = !hasTarget ".config/opencode/superpowers";
  noProfileSuperpowersPlugin =
    !hasTarget ".config/opencode-superpowers/opencode/plugins/superpowers.js";
  noProfileSuperpowersSkills = !hasTarget ".config/opencode-superpowers/opencode/skills/superpowers";
  noProfileSuperpowersTree = !hasTarget ".config/opencode-superpowers/opencode/superpowers";
  noLegacySuperpowersPackage = !(builtins.elem "opencode-superpowers" packageNames);
  keepsCavemanSkill = hasTarget ".config/opencode/skills/caveman";
}
