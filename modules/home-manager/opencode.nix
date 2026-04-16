{
  config,
  pkgs,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  cavemanSrc = inputs.caveman;
  opencodePackage = pkgs.opencode;
  defaultOpencodeConfig = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";

    model = "copilot/claude-sonnet-4-5";
    small_model = "copilot/gpt-4o-mini";

    disabled_providers = [ ];

    keybinds = {
      leader = "ctrl+o";
    };

    autoupdate = false;

    lsp = {
      typescript = {
        command = [
          "typescript-language-server"
          "--stdio"
        ];
        extensions = [
          "ts"
          "tsx"
          "js"
          "jsx"
          "mjs"
          "cjs"
        ];
      };
      python = {
        command = [
          "pyright-langserver"
          "--stdio"
        ];
        extensions = [
          "py"
          "pyi"
        ];
      };
      go = {
        command = [ "gopls" ];
        extensions = [ "go" ];
      };
      c = {
        command = [
          "clangd"
          "--background-index"
        ];
        extensions = [
          "c"
          "h"
        ];
      };
      cpp = {
        command = [
          "clangd"
          "--background-index"
        ];
        extensions = [
          "cc"
          "cpp"
          "cxx"
          "hpp"
          "hh"
          "hxx"
        ];
      };
      nix = {
        command = [ "nil" ];
        extensions = [ "nix" ];
      };
    };
  };

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
  # === OpenCode Configuration ===
  # AI coding agent for the terminal — https://opencode.ai
  # Config file spec: https://opencode.ai/docs/configuration
  #
  # Managed via home.file so it lands at:
  #   ~/.config/opencode/config.json

  xdg.configFile."opencode/config.json".text = defaultOpencodeConfig;
  xdg.configFile."opencode/AGENTS.md".text = ''
    Terse like caveman. Technical substance exact. Only fluff die.
    Drop: articles, filler (just/really/basically), pleasantries, hedging.
    Fragments OK. Short synonyms. Code unchanged.
    Pattern: [thing] [action] [reason]. [next step].
    ACTIVE EVERY RESPONSE. No revert after many turns. No filler drift.
    Code/commits/PRs: normal. Off: "stop caveman" / "normal mode".
  '';

  xdg.configFile."claude/CLAUDE.md".text = ''
    Terse like caveman. Technical substance exact. Only fluff die.
    Drop: articles, filler (just/really/basically), pleasantries, hedging.
    Fragments OK. Short synonyms. Code unchanged.
    Pattern: [thing] [action] [reason]. [next step].
    ACTIVE EVERY RESPONSE. No revert after many turns. No filler drift.
    Code/commits/PRs: normal. Off: "stop caveman" / "normal mode".
  '';

  # === Peon Ping ===
  # Agent voice/notification integration + OpenCode plugin adapter
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

  # Install both default and community packs declaratively
  home.file.".openpeon/packs" = {
    source = peonPacks;
    recursive = true;
  };

  # OpenCode plugin and adapter config
  xdg.configFile."opencode/plugins/peon-ping.ts".source = "${
    inputs.peon-ping.packages.${system}.default
  }/share/peon-ping/adapters/opencode/peon-ping.ts";

  xdg.configFile."opencode/plugins/caveman" = {
    source = "${cavemanSrc}/plugins/caveman";
    recursive = true;
  };

  xdg.configFile."opencode/skills/caveman" = {
    source = "${cavemanSrc}/skills/caveman";
    recursive = true;
  };

  xdg.configFile."opencode/skills/caveman-commit" = {
    source = "${cavemanSrc}/skills/caveman-commit";
    recursive = true;
  };

  xdg.configFile."opencode/skills/caveman-review" = {
    source = "${cavemanSrc}/skills/caveman-review";
    recursive = true;
  };

  xdg.configFile."opencode/skills/caveman-compress" = {
    source = "${cavemanSrc}/caveman-compress";
    recursive = true;
  };

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
