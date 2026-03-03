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
        program = "${pkgs.bash}/bin/bash";
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

  # === Bash Configuration ===
  programs.bash = {
    enable = true;
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
  };
}
