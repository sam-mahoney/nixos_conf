{ inputs, theme, ... }:

let
  p = theme.palette;
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
        displayMode = "always_visible";
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

      location = {
        name = "London";
        autoLocate = false;
        weatherEnabled = true;
        useFahrenheit = false;
        showCalendarWeather = true;
      };

      launcher = {
        showRecentApps = true;
        maxRecentApps = 5;
      };
    };

    colors = {
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
}
