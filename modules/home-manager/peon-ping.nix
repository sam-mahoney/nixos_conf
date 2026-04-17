{
  pkgs,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;

  ogPacksVersion = "1.4.0";
  ogPacksSrc = pkgs.fetchzip {
    url = "https://github.com/PeonPing/og-packs/archive/refs/tags/v${ogPacksVersion}.tar.gz";
    sha256 = "sha256-jkybxNrXfc8GFPAi0Lb1rF8fsx8Z8K0k5gQxh8Y62Ds=";
    stripRoot = false;
  };

  jarvisMk2Pack = pkgs.fetchFromGitHub {
    owner = "FlynnCruse";
    repo = "openpeon-jarvis";
    rev = "v1.0.0";
    sha256 = "1w0p1znkwd3zclrphfmad4z2a481hpg0s0rh96in8rzww2cvrqn0";
  };

  peonPacks = pkgs.runCommand "peon-packs-custom" { } ''
    mkdir -p "$out"
    cp -r "${ogPacksSrc}/og-packs-${ogPacksVersion}/peon" "$out/"
    cp -r "${jarvisMk2Pack}" "$out/jarvis-mk2"
  '';
in
{
  imports = [ inputs.peon-ping.homeManagerModules.default ];

  programs.peon-ping = {
    enable = true;
    package = inputs.peon-ping.packages.${system}.default;
    enableZshIntegration = false;
    settings = {
      default_pack = "jarvis-mk2";
      volume = 0.5;
      enabled = false;
      desktop_notifications = true;
      categories = {
        "session.start" = true;
        "task.complete" = true;
        "task.error" = true;
        "input.required" = true;
        "resource.limit" = true;
        "user.spam" = true;
      };
    };
  };

  home.file.".openpeon/packs" = {
    source = peonPacks;
    recursive = true;
  };

  xdg.configFile."opencode/plugins/peon-ping.ts".source = "${
    inputs.peon-ping.packages.${system}.default
  }/share/peon-ping/adapters/opencode/peon-ping.ts";

  xdg.configFile."opencode/peon-ping/config.json".text = builtins.toJSON {
    active_pack = "jarvis-mk2";
    volume = 0.5;
    enabled = false;
    desktop_notifications = true;
    categories = {
      "session.start" = true;
      "task.acknowledge" = true;
      "task.complete" = true;
      "task.error" = true;
      "input.required" = true;
      "resource.limit" = true;
      "user.spam" = true;
    };
    pack_rotation = [ ];
  };

  programs.zsh.initContent = ''
    source ${
      inputs.peon-ping.packages.${system}.default
    }/share/zsh/site-functions/_peon 2>/dev/null || true
    alias peon="${inputs.peon-ping.packages.${system}.default}/bin/peon"
  '';
}
