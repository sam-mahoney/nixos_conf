# Shared Oxocarbon palette (IBM Carbon) and fonts.
# Source: https://github.com/nyoom-engineering/oxocarbon.nvim
# Change a value here and it updates everywhere: terminal, editor, compositor, status bar.
let
  palette = {
    bg        = "#161616"; # base00
    bg_alt    = "#262626"; # base01
    fg        = "#dde1e6"; # base04
    fg_bright = "#f2f4f8"; # base05
    white     = "#ffffff"; # base06
    gray1     = "#c6c6c6"; # Carbon gray 30
    gray2     = "#a8a8a8"; # Carbon gray 40
    gray3     = "#8d8d8d"; # Carbon gray 50
    gray4     = "#6f6f6f"; # Carbon gray 60
    gray5     = "#393939"; # base02
    red       = "#ee5396"; # base10

    teal      = "#08bdba"; # base07
    cyan      = "#3ddbd9"; # base08
    blue      = "#78a9ff"; # base09
    sky       = "#33b1ff"; # base11
    pink      = "#ff7eb6"; # base12
    green     = "#42be65"; # base13
    purple    = "#be95ff"; # base14
    lightblue = "#82cfff"; # base15
  };
in
{
  inherit palette;

  # 16-colour terminal set. Oxocarbon has no yellow, so pink fills that slot.
  ansi = with palette; {
    normal = {
      black = bg_alt; red = red; green = green; yellow = pink;
      blue = sky; magenta = purple; cyan = cyan; white = fg_bright;
    };
    bright = {
      black = "#525252"; red = red; green = green; yellow = pink;
      blue = sky; magenta = purple; cyan = cyan; white = white;
    };
  };

  fonts = {
    mono = "JetBrainsMono Nerd Font";
  };

  # Tiling gaps in pixels, shared by Sway and AeroSpace.
  # inner: between windows. outer: between windows and the screen edge.
  gaps = {
    inner = 6;
    outer = 6;
  };
}
