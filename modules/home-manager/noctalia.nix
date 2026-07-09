{ inputs, theme, ... }:

let
  p = theme.palette;
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;

    settings = {
      shell = {
        time_format = "{:%H:%M}";
        date_format = "%A, %x";
      };

      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "mono";
      };

      bar.main = {
        position = "top";
        background_opacity = 1.0;
        scale = 0.95;
        widget_spacing = 4;
        padding = 6;
        margin_h = 0;
        margin_v = 0;
        radius = 0;
        capsule = true;
        capsule_fill = "surface_variant";
        capsule_opacity = 0.4;
        start = [ "workspaces" ];
        center = [ "clock" ];
        end = [
          "network"
          "volume"
          "battery"
          "tray"
        ];
      };

      widget.clock = {
        format = "{:%a %H:%M}";
      };

      notification = {
        enable_daemon = true;
      };

      osd = {
        position = "bottom_center";
      };

      weather = {
        enabled = true;
        unit = "celsius";
      };

      location = {
        auto_locate = false;
        address = "London";
      };

      battery = {
        warning_threshold = 20;
      };
    };

    customPalettes.mono = {
      dark = {
        mPrimary = p.gray3;
        mOnPrimary = p.bg;
        mSecondary = p.gray4;
        mOnSecondary = p.bg;
        mTertiary = p.gray4;
        mOnTertiary = p.bg;
        mError = p.red;
        mOnError = p.bg;
        mSurface = p.bg;
        mOnSurface = p.gray2;
        mSurfaceVariant = p.bg_alt;
        mOnSurfaceVariant = p.gray4;
        mOutline = p.gray5;
        mShadow = p.bg;
        mHover = p.bg_alt;
        mOnHover = p.gray2;
        terminal = {
          normal = {
            black = p.bg;
            red = p.red;
            green = p.gray3;
            yellow = p.gray2;
            blue = p.gray3;
            magenta = p.gray4;
            cyan = p.gray2;
            white = p.gray1;
          };
          bright = {
            black = p.gray5;
            red = p.red;
            green = p.fg;
            yellow = p.fg_bright;
            blue = p.fg;
            magenta = p.gray2;
            cyan = p.fg_bright;
            white = p.white;
          };
          foreground = p.fg;
          background = p.bg;
          cursor = p.fg_bright;
          cursorText = p.bg;
          selectionFg = p.bg;
          selectionBg = p.gray2;
        };
      };
    };
  };
}
