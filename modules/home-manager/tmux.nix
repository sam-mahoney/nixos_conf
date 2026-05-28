{ pkgs, theme, ... }:

let
  p = theme.palette;
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
      set -ag terminal-overrides ",alacritty:RGB"

      # Theme
      set -g status on
      set -g status-position bottom
      set -g status-justify left
      set -g status-interval 5
      set -g status-style "bg=${p.bg},fg=${p.gray1}"
      set -g message-style "bg=${p.bg},fg=${p.fg_bright}"
      set -g message-command-style "bg=${p.bg},fg=${p.fg_bright}"
      set -g pane-border-style "fg=${p.gray5}"
      set -g pane-active-border-style "fg=${p.gray2}"
      setw -g window-status-style "bg=${p.bg},fg=${p.gray4}"
      setw -g window-status-current-style "bg=${p.bg},fg=${p.white},bold"
      set -g status-left "#[fg=${p.gray2}]#S #[fg=${p.gray4}]| "
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

      # Reload
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      set -g allow-rename off
      setw -g monitor-activity on
      set -g visual-activity off

      # Copy mode (vi-style, wl-copy for Wayland)
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "wl-copy"
      bind -T copy-mode-vi q send -X cancel
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "wl-copy"

      # Send prefix to nested tmux
      bind a send-prefix
    '';
  };
}
