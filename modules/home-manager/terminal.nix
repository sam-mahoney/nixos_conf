{ config, ... }:

{
  # === Alacritty Terminal Emulator ===
  # Fast, GPU-accelerated terminal written in Rust
  # Opens regular login shells by default (tmux is optional/manual)
  # https://alacritty.org/
  programs.alacritty = {
    enable = true;
    
    settings = {
      # Set TERM variable for proper color support
      env.TERM = "xterm-256color";
      
      # Copy to clipboard on selection
      selection.save_to_clipboard = true;

      # === Font Configuration ===
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        size = 12.0;
      };

      # === Geohot-style Colors (minimal black/grey/white) ===
      colors = {
        primary = {
          background = "#000000";
          foreground = "#d8d8d8";
        };
        cursor = {
          text = "#000000";
          cursor = "#c0c0c0";
        };
        selection = {
          text = "#000000";
          background = "#9a9a9a";
        };
      };

      # === Window Settings ===
      window = {
        padding = { x = 4; y = 4; };
        opacity = 1.0;
      };

      # Use default login shell behavior (no auto-attach to tmux)
    };
  };

  # === Starship Prompt ===
  # Cross-shell prompt with Git integration and rich context
  # https://starship.rs/
  programs.starship = {
    enable = true;
    settings = {
      # Minimal prompt that works well with tmux status bar
      format = "$directory$git_branch$git_status$status$character";
      
      directory = {
        truncation_length = 3;
        style = "bold #c8c8c8";
      };
      
      git_branch = {
        style = "#9c9c9c";
      };
      
      git_status = {
        style = "#7a7a7a";
      };

      status = {
        disabled = false;
        format = '' [$status](bold #ff8a8a)'';
      };
      
      character = {
        success_symbol = "[❯](bold #e6e6e6)";
        error_symbol = "[❯](bold #ff8a8a)";
      };
    };
  };

  # === Zsh Configuration ===
  # Feature-rich shell with smart autocompletion, syntax highlighting,
  # history-based suggestions, and fuzzy search
  programs.zsh = {
    enable = true;

    # --- Aliases ---
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";
      ta = "tmux attach -t main || tmux new -s main";

      # OpenCode helper aliases
      astq = "sg scan --json";
      symidx = "ctags -R --output-format=json";
      diag = "nix flake check";
      timp = "git diff --name-only";
    };

    # --- History ---
    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;      # Don't store duplicate commands
      ignoreAllDups = true;   # Remove older duplicate when new one added
      ignoreSpace = true;     # Don't store commands starting with space
      extended = true;         # Save timestamps
      share = true;            # Share history across sessions
    };

    # --- Completion System ---
    enableCompletion = true;   # Enable zsh completion system
    completionInit = ''
      # Case-insensitive, partial-word, and substring completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      # Menu-driven completion with highlighting
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors "$${(s.:.)LS_COLORS}"

      # Group completions by category
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*:descriptions' format '%F{blue}-- %d --%f'
      zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'

      # Cache completions for faster results
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$HOME/.zsh/cache"

      # Complete PIDs with menu
      zstyle ':completion:*:*:kill:*' menu yes select
      zstyle ':completion:*:kill:*' force-list always
    '';

    # --- Plugins ---
    autosuggestion = {
      enable = true;           # Fish-like suggestions from history
      strategy = [ "history" "completion" ];
    };
    syntaxHighlighting.enable = true;  # Real-time command highlighting

    # --- Extra Options ---
    initContent = ''
      # Navigate directory stack with cd -<number>
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_SILENT

      # Better globbing
      setopt EXTENDED_GLOB
      unsetopt NOMATCH   # Don't error on unmatched globs (needed for nix flake refs like .#helios)

      # Up/Down arrow searches history matching current input
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      # Ctrl+R for fuzzy history search (fzf)
      if command -v fzf &> /dev/null; then
        source <(fzf --zsh 2>/dev/null || true)
      fi
    '';
  };

  # Keep bash available as fallback
  programs.bash.enable = true;

  # fzf — powers Ctrl+R fuzzy history search and ** tab completions
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--height=40%" "--layout=reverse" "--border" ];
  };
}
