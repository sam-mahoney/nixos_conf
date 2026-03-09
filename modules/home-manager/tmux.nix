{ config, pkgs, ... }:

{
  # === tmux - Terminal Multiplexer ===
  # Persistent terminal sessions with splits and tabs
  # Launch tmux manually when needed (`tmux` / `tmux attach`)
  #
  # Quick reference:
  #   Prefix: Ctrl+a (like screen, easier than Ctrl+b)
  #   Prefix + |  → vertical split
  #   Prefix + -  → horizontal split
  #   Prefix + h/j/k/l → navigate panes (vim-style)
  #   Prefix + H/J/K/L → resize panes
  #   Alt+h/j/k/l      → navigate panes (no prefix)
  #   Alt+Shift+hjkl   → resize panes (no prefix)
  #   Prefix + c  → new window
  #   Prefix + n/p → next/prev window
  #   Prefix + 1-9 → switch to window
  #   Prefix + d  → detach
  #   Prefix + [  → copy mode (vim keys)

  programs.tmux = {
    enable = true;
    
    # --- Core Settings ---
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
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
    ];

    # --- Extra Configuration ---
    extraConfig = ''
      # === True Color Support ===
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ag terminal-overrides ",alacritty:RGB"

      # === Geohot-style Minimal Theme (black/grey/white) ===
      set -g status on
      set -g status-position bottom
      set -g status-justify left
      set -g status-interval 5
      set -g status-style "bg=#000000,fg=#b0b0b0"
      set -g message-style "bg=#000000,fg=#e6e6e6"
      set -g message-command-style "bg=#000000,fg=#e6e6e6"
      set -g pane-border-style "fg=#3a3a3a"
      set -g pane-active-border-style "fg=#a0a0a0"
      setw -g window-status-style "bg=#000000,fg=#6f6f6f"
      setw -g window-status-current-style "bg=#000000,fg=#ffffff,bold"
      set -g status-left "#[fg=#a0a0a0]#S #[fg=#5f5f5f]| "
      set -g status-right "#[fg=#5f5f5f]%Y-%m-%d #[fg=#a0a0a0]%H:%M "
      set -g status-left-length 30
      set -g status-right-length 50

      # === Split Panes (intuitive keys) ===
      bind | split-window -h -c "#{pane_current_path}"
      bind \\ split-window -h -c "#{pane_current_path}"   # Backslash also splits (no Shift needed)
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # === Pane Navigation (vim-style) ===
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # === Prefixless pane navigation (matches Mod+h/j/k/l muscle memory) ===
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # === Pane Resizing (vim-style with Shift) ===
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # === Prefixless pane resize (Alt+Shift+hjkl) ===
      bind -n M-H resize-pane -L 5
      bind -n M-J resize-pane -D 5
      bind -n M-K resize-pane -U 5
      bind -n M-L resize-pane -R 5

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
      bind -T copy-mode-vi q send -X cancel
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "wl-copy"

      # === Send prefix to nested tmux (press prefix twice) ===
      bind a send-prefix
    '';
  };
}
