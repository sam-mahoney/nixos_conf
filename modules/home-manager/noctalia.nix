{ inputs, ... }:

let
  p = (import ../theme.nix).palette;
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;

    settings = {
      bar = {
        position = "top";
        density = "compact";
        barType = "simple";
        backgroundOpacity = 1.0;
        showCapsule = true;
        capsuleOpacity = 0.4;
        capsuleColorKey = "mSurfaceVariant";
        showOutline = false;
        widgetSpacing = 4;
        contentPadding = 6;
        fontScale = 0.95;
        widgets = {
          left = [
            {
              id = "Workspace";
              hideUnoccupied = true;
              labelMode = "number";
              pillSize = 0.7;
              fontWeight = "medium";
              focusedColor = "mPrimary";
              occupiedColor = "mOnSurfaceVariant";
              emptyColor = "mOutline";
              enableScrollWheel = false;
            }
          ];
          center = [
            { id = "Clock"; formatHorizontal = "ddd HH:mm"; usePrimaryColor = false; useMonospacedFont = true; }
          ];
          right = [
            { id = "Network"; }
            { id = "Volume"; }
            { id = "Battery"; alwaysShowPercentage = true; warningThreshold = 20; }
            { id = "Tray"; }
          ];
        };
      };

      colorSchemes = {
        darkMode = true;
        useWallpaperColors = false;
        predefinedScheme = "";
      };

      notifications = {
        position = "top-right";
        width = 400;
        timeout = 5000;
      };

      osd = {
        enabled = true;
        position = "bottom";
      };

      launcher = {
        showRecentApps = true;
        maxRecentApps = 5;
      };
    };

    colors = {
      mPrimary = p.gray1;
      mOnPrimary = p.bg;
      mSecondary = p.gray3;
      mOnSecondary = p.bg;
      mTertiary = p.gray2;
      mOnTertiary = p.bg;
      mError = p.red;
      mOnError = p.bg;
      mSurface = p.bg;
      mOnSurface = p.fg;
      mSurfaceVariant = p.gray5;
      mOnSurfaceVariant = p.gray3;
      mOutline = p.gray4;
      mShadow = p.bg;
      mHover = p.gray5;
      mOnHover = p.fg;
    };
  };
}
