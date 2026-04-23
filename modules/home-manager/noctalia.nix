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
        barType = "floating";
        marginVertical = 6;
        marginHorizontal = 10;
        backgroundOpacity = 0.85;
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
      mPrimary = p.fg_bright;
      mOnPrimary = p.bg;
      mSecondary = p.gray2;
      mOnSecondary = p.bg;
      mTertiary = p.gray1;
      mOnTertiary = p.bg;
      mError = p.red;
      mOnError = p.bg;
      mSurface = p.bg;
      mOnSurface = p.fg;
      mSurfaceVariant = p.gray5;
      mOnSurfaceVariant = p.gray2;
      mOutline = p.gray4;
      mShadow = p.bg;
      mHover = p.gray5;
      mOnHover = p.fg;
    };
  };
}
