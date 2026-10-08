{ theme, ... }:

let
  p = theme.palette;
  monoFont = theme.fonts.mono;
in
{
  programs.alacritty = {
    enable = true;

    settings = {
      env.TERM = "xterm-256color";
      selection.save_to_clipboard = true;

      font = {
        normal = { family = monoFont; style = "Regular"; };
        bold = { family = monoFont; style = "Bold"; };
        italic = { family = monoFont; style = "Italic"; };
        size = 12.0;
      };

      colors = {
        # Brighter foreground keeps text legible over a see-through background
        primary = { background = p.bg; foreground = p.fg_bright; };
        cursor = { text = p.bg; cursor = p.blue; };
        selection = { text = "CellForeground"; background = p.gray5; };
        normal = theme.ansi.normal;
        bright = theme.ansi.bright;
      };

      window = {
        padding = { x = 4; y = 4; };
        # Only the default background goes translucent; apps that paint their
        # own bg (nvim, tmux) must use NONE/default to stay see-through.
        opacity = 0.6;
        # Honoured on macOS; stock Sway has no blur protocol so it's ignored there
        blur = true;
        decorations = "None";
      };
    };
  };
}
