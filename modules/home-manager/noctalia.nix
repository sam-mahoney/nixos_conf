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
        custom_palette = "oxocarbon";
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

    customPalettes.oxocarbon = {
      dark = {
        mPrimary = p.blue;
        mOnPrimary = p.bg;
        mSecondary = p.purple;
        mOnSecondary = p.bg;
        mTertiary = p.cyan;
        mOnTertiary = p.bg;
        mError = p.red;
        mOnError = p.bg;
        mSurface = p.bg;
        mOnSurface = p.fg;
        mSurfaceVariant = p.bg_alt;
        mOnSurfaceVariant = p.gray3;
        mOutline = p.gray5;
        mShadow = p.bg;
        mHover = p.bg_alt;
        mOnHover = p.fg_bright;
        terminal = {
          inherit (theme.ansi) normal bright;
          foreground = p.fg_bright;
          background = p.bg;
          cursor = p.blue;
          cursorText = p.bg;
          selectionFg = p.fg_bright;
          selectionBg = p.gray5;
        };
      };
    };
  };
}
