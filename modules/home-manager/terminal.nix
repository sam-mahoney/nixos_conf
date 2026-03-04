{ config, pkgs, ... }:

{
  # === Alacritty Terminal Emulator ===
  # Fast, GPU-accelerated terminal written in Rust
  # Configured to auto-launch tmux on every new terminal
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

      # === Catppuccin Mocha Colors ===
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
        cursor = {
          text = "#1e1e2e";
          cursor = "#f5e0dc";
        };
        normal = {
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#bac2de";
        };
        bright = {
          black = "#585b70";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#a6adc8";
        };
      };

      # === Window Settings ===
      window = {
        padding = { x = 8; y = 8; };
        opacity = 0.95;
      };

      # === Auto-launch tmux ===
      # Attach to existing session or create a new one
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "-l" "-c" "tmux new-session -A -s main" ];
      };
    };
  };

  # === Starship Prompt ===
  # Cross-shell prompt with Git integration and rich context
  # https://starship.rs/
  programs.starship = {
    enable = true;
    settings = {
      # Minimal prompt that works well with tmux status bar
      format = "$directory$git_branch$git_status$character";
      
      directory = {
        truncation_length = 3;
        style = "bold blue";
      };
      
      git_branch = {
        style = "bold purple";
      };
      
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
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
      zstyle ':completion:*' group-name ''''
      zstyle ':completion:*:descriptions' format '%%F{blue}-- %%d --%%f'
      zstyle ':completion:*:warnings' format '%%F{red}-- no matches --%%f'

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
      setopt NOMATCH

      # Correct typos in commands
      setopt CORRECT

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
