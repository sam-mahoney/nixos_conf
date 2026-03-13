{ config, pkgs, inputs, ... }:

{
  # === Noctalia Shell ===
  # A beautiful, minimal desktop shell for Wayland built on Quickshell
  # Replaces waybar with a complete desktop shell including:
  #   - Status bar with workspaces, clock, battery, network, bluetooth, tray
  #   - Notification system with history and Do Not Disturb
  #   - Control center / quick settings panel
  #   - App launcher
  #   - OSD for volume and brightness
  #   - Lock screen (optional — we use swaylock instead)
  #
  # https://docs.noctalia.dev/
  # https://github.com/noctalia-dev/noctalia-shell

  # Import the Noctalia home-manager module from the flake
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;

    # === Shell Settings ===
    settings = {
      # --- Bar Configuration ---
      bar = {
        position = "top";
        density = "compact";
        showCapsule = false;
        backgroundOpacity = 1.0;
        floating = false;

        widgets = {
          left = [
            {
              id = "Workspace";
              hideUnoccupied = true;
              labelMode = "number";
            }
          ];
          center = [
            {
              id = "Clock";
              formatHorizontal = "ddd HH:mm";
              usePrimaryColor = false;
              useMonospacedFont = true;
            }
          ];
          right = [
            {
              id = "Network";
            }
            {
              id = "Volume";
            }
            {
              id = "Battery";
              alwaysShowPercentage = true;
              warningThreshold = 20;
            }
            {
              id = "Tray";
            }
          ];
        };
      };

      # --- Color Scheme ---
      colorSchemes = {
        darkMode = true;
        useWallpaperColors = false;
        predefinedScheme = "";
      };

      # --- Notifications ---
      notifications = {
        position = "top-right";
        width = 400;
        timeout = 5000;
      };

      # --- OSD (On-Screen Display) ---
      osd = {
        enabled = true;
        position = "bottom";
      };

      # --- Launcher ---
      launcher = {
        showRecentApps = true;
        maxRecentApps = 5;
      };
    };

    # --- Geohot-style monochrome colors ---
    colors = {
      mPrimary = "#c0c0c0";
      mOnPrimary = "#000000";
      mSecondary = "#9a9a9a";
      mOnSecondary = "#000000";
      mTertiary = "#d8d8d8";
      mOnTertiary = "#000000";
      mError = "#ff8080";
      mOnError = "#000000";
      mSurface = "#000000";
      mOnSurface = "#d8d8d8";
      mSurfaceVariant = "#111111";
      mOnSurfaceVariant = "#9a9a9a";
      mOutline = "#3a3a3a";
      mShadow = "#000000";
      mHover = "#9a9a9a";
      mOnHover = "#000000";
    };
  };
}
