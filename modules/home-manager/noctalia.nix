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
        showCapsule = false;
        backgroundOpacity = 1.0;
        floating = false;
        widgets = {
          left = [
            { id = "Workspace"; hideUnoccupied = true; labelMode = "number"; }
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
      mTertiary = p.fg;
      mOnTertiary = p.bg;
      mError = p.red;
      mOnError = p.bg;
      mSurface = p.bg;
      mOnSurface = p.fg;
      mSurfaceVariant = p.bg_alt;
      mOnSurfaceVariant = p.gray3;
      mOutline = p.gray5;
      mShadow = p.bg;
      mHover = p.gray3;
      mOnHover = p.bg;
    };
  };
}
