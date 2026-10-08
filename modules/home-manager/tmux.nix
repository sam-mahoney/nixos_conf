{ pkgs, theme, ... }:

let
  p = theme.palette;
  # These binds load after tmux-yank and replace its auto-detected command, so pick per platform
  copyCmd = if pkgs.stdenv.isDarwin then "pbcopy" else "wl-copy";
in
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    baseIndex = 1;
    escapeTime = 50;
    historyLimit = 50000;
    mouse = true;
    keyMode = "vi";
    prefix = "C-a";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
    ];

    extraConfig = ''
      # True color support
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ag terminal-overrides ",xterm-ghostty:RGB"

      # Theme
      set -g status on
      set -g status-position bottom
      set -g status-justify left
      set -g status-interval 5
      # bg=default keeps the bar transparent in a translucent terminal
      set -g status-style "bg=default,fg=${p.gray1}"
      set -g message-style "bg=default,fg=${p.fg_bright}"
      set -g message-command-style "bg=default,fg=${p.fg_bright}"
      set -g pane-border-style "fg=${p.gray5}"
      set -g pane-active-border-style "fg=${p.blue}"
      setw -g window-status-style "bg=default,fg=${p.gray4}"
      setw -g window-status-current-style "bg=default,fg=${p.blue},bold"
      # Windows double as terminal tabs (see ghostty.nix), so style them like a tab bar
      setw -g window-status-format " #I #W "
      setw -g window-status-current-format " #I #W "
      set -g window-status-separator ""
      set -g status-left "#[fg=${p.purple}]#S #[fg=${p.gray4}]| "
      set -g status-right "#[fg=${p.gray4}]%Y-%m-%d #[fg=${p.gray2}]%H:%M "
      set -g status-left-length 30
      set -g status-right-length 50

      # Splits
      bind | split-window -h -c "#{pane_current_path}"
      bind \\ split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Pane navigation (vim-style)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Prefixless pane navigation
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Pane resize
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Prefixless pane resize
      bind -n M-H resize-pane -L 5
      bind -n M-J resize-pane -D 5
      bind -n M-K resize-pane -U 5
      bind -n M-L resize-pane -R 5

      # Windows
      bind c new-window -c "#{pane_current_path}"
      # Keep numbering gap-free so Cmd+1-9 in Ghostty always hits the Nth tab
      set -g renumber-windows on

      # Reload
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      set -g allow-rename off
      setw -g monitor-activity on
      set -g visual-activity off

      # Copy mode (vi-style; pbcopy on macOS, wl-copy on Wayland)
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "${copyCmd}"
      bind -T copy-mode-vi q send -X cancel
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "${copyCmd}"

      # Send prefix to nested tmux
      bind a send-prefix
    '';
  };
}
