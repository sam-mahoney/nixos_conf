{
  config,
  pkgs,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  superpowersSrc = inputs.superpowers;

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

  xdg.configFile."opencode/config.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";

    # --- Model Selection ---
    # Format: "provider/model"
    # Copilot models are free if you have a GitHub Copilot subscription.
    # Switch to "anthropic/claude-sonnet-4-5" etc. if you set ANTHROPIC_API_KEY.
    model = "copilot/claude-sonnet-4-5";
    small_model = "copilot/gpt-4o-mini";

    # --- Providers ---
    # Copilot auth is picked up automatically from gh CLI or VS Code extension.
    # No API key needed if you have a Copilot subscription.
    disabled_providers = [ ];

    # --- Shell ---
    # Use zsh so opencode's bash tool inherits your aliases and environment
    # (matches the login shell set in users.nix)
    # Note: this configures the shell used for bash tool execution, not the TUI
    # shell. Opencode does not have a top-level shell config key; set via env.

    # --- Keybinds ---
    # Override the default leader key (ctrl+x) to avoid conflicts with tmux
    keybinds = {
      leader = "ctrl+o"; # ctrl+x clashes with tmux; ctrl+o is free in sway
    };

    # --- Autoupdate ---
    # Disable since version is managed by Nix
    autoupdate = false;

    # --- LSP ---
    # Enable language servers for diagnostics — the AI can read errors directly.
    # command must be an array; args are included in the same array.
    # Add more as needed (rust-analyzer, pyright, etc.)
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

  # === Peon Ping ===
  # Agent voice/notification integration + OpenCode plugin adapter
  programs.peon-ping = {
    enable = true;
    package = inputs.peon-ping.packages.${system}.default;
    enableZshIntegration = false;
    settings = {
      default_pack = "jarvis-mk2";
      volume = 0.5;
      enabled = true;
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

  xdg.configFile."opencode/plugins/superpowers.js".source =
    "${superpowersSrc}/.opencode/plugins/superpowers.js";

  xdg.configFile."opencode/skills/superpowers" = {
    source = "${superpowersSrc}/skills";
    recursive = true;
  };

  xdg.configFile."opencode/superpowers" = {
    source = superpowersSrc;
    recursive = true;
  };

  xdg.configFile."opencode/peon-ping/config.json".text = builtins.toJSON {
    active_pack = "jarvis-mk2";
    volume = 0.5;
    enabled = true;
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
