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
        primary = { background = p.bg; foreground = p.fg; };
        cursor = { text = p.bg; cursor = p.gray1; };
        selection = { text = p.bg; background = p.gray3; };
      };

      window = {
        padding = { x = 4; y = 4; };
        opacity = 1.0;
        decorations = "None";
      };
    };
  };
}
