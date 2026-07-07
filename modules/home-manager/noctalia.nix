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
      };
    };
  };
}
