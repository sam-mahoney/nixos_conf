{ config, pkgs, ... }:

{
  # === tmux - Terminal Multiplexer ===
  # Persistent terminal sessions with splits and tabs
  # All terminals auto-launch tmux (see terminal.nix)
  #
  # Quick reference:
  #   Prefix: Ctrl+a (like screen, easier than Ctrl+b)
  #   Prefix + |  → vertical split
  #   Prefix + -  → horizontal split
  #   Prefix + h/j/k/l → navigate panes (vim-style)
  #   Prefix + H/J/K/L → resize panes
  #   Prefix + c  → new window
  #   Prefix + n/p → next/prev window
  #   Prefix + 1-9 → switch to window
  #   Prefix + d  → detach
  #   Prefix + [  → copy mode (vim keys)

  programs.tmux = {
    enable = true;
    
    # --- Core Settings ---
    terminal = "tmux-256color";
    shell = "${pkgs.bash}/bin/bash";
    baseIndex = 1;               # Windows start at 1 (not 0)
    escapeTime = 0;              # No delay after pressing Escape
    historyLimit = 50000;        # Generous scrollback
    mouse = true;                # Enable mouse support
    keyMode = "vi";              # Vi-style key bindings in copy mode
    
    # --- Prefix Key ---
    # Ctrl+a is more ergonomic than the default Ctrl+b
    prefix = "C-a";
    
    # --- Plugins ---
    plugins = with pkgs.tmuxPlugins; [
      sensible        # Sensible defaults everyone can agree on
      yank            # Copy to system clipboard
      {
        # Catppuccin theme to match Sway/Noctalia aesthetic
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"

          # Window format
          set -g @catppuccin_window_number_position "left"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_text "#W"

          # Status bar modules
          set -g @catppuccin_status_modules_right "session date_time"
          set -g @catppuccin_date_time_text "%H:%M"
        '';
      }
    ];

    # --- Extra Configuration ---
    extraConfig = ''
      # === True Color Support ===
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ag terminal-overrides ",alacritty:RGB"

      # === Split Panes (intuitive keys) ===
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # === Pane Navigation (vim-style) ===
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # === Pane Resizing (vim-style with Shift) ===
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # === Window Management ===
      bind c new-window -c "#{pane_current_path}"

      # === Quick Reload ===
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # === Don't rename windows automatically ===
      set -g allow-rename off

      # === Activity Monitoring ===
      setw -g monitor-activity on
      set -g visual-activity off

      # === Better copy mode (vi-style) ===
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "wl-copy"
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "wl-copy"

      # === Send prefix to nested tmux (press prefix twice) ===
      bind a send-prefix
    '';
  };
}
