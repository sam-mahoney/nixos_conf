{ config, pkgs, ... }:

{
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
      leader = "ctrl+o";  # ctrl+x clashes with tmux; ctrl+o is free in sway
    };

    # --- Autoupdate ---
    # Disable since version is managed by Nix
    autoupdate = false;

    # --- LSP ---
    # Enable language servers for diagnostics — the AI can read errors directly.
    # Add more as needed (rust-analyzer, nil for Nix, etc.)
    lsp = {
      typescript = {
        disabled = false;
        command = "typescript-language-server";
        args = [ "--stdio" ];
      };
      nix = {
        disabled = false;
        command = "nil";
      };
    };
  };

  # Ensure LSP servers referenced above are available
  home.packages = with pkgs; [
    nodePackages.typescript-language-server
    nil   # Nix language server
  ];
}
