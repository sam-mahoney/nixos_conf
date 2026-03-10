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
      dark = {
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
        terminal = {
          normal = {
            black = "#111111";
            red = "#ff8080";
            green = "#b8b8b8";
            yellow = "#d0d0d0";
            blue = "#9a9a9a";
            magenta = "#b0b0b0";
            cyan = "#c0c0c0";
            white = "#e6e6e6";
          };
          bright = {
            black = "#2a2a2a";
            red = "#ff9a9a";
            green = "#c6c6c6";
            yellow = "#dddddd";
            blue = "#b0b0b0";
            magenta = "#c4c4c4";
            cyan = "#d4d4d4";
            white = "#ffffff";
          };
          foreground = "#d8d8d8";
          background = "#000000";
          selectionFg = "#000000";
          selectionBg = "#9a9a9a";
          cursorText = "#000000";
          cursor = "#c0c0c0";
        };
      };
      light = {
        mPrimary = "#3a3a3a";
        mOnPrimary = "#f2f2f2";
        mSecondary = "#505050";
        mOnSecondary = "#f2f2f2";
        mTertiary = "#2a2a2a";
        mOnTertiary = "#f2f2f2";
        mError = "#b00020";
        mOnError = "#f2f2f2";
        mSurface = "#f2f2f2";
        mOnSurface = "#111111";
        mSurfaceVariant = "#e0e0e0";
        mOnSurfaceVariant = "#505050";
        mOutline = "#bdbdbd";
        mShadow = "#d0d0d0";
        mHover = "#3a3a3a";
        mOnHover = "#f2f2f2";
        terminal = {
          normal = {
            black = "#e0e0e0";
            red = "#b00020";
            green = "#707070";
            yellow = "#5a5a5a";
            blue = "#6a6a6a";
            magenta = "#585858";
            cyan = "#4f4f4f";
            white = "#111111";
          };
          bright = {
            black = "#bdbdbd";
            red = "#a0001a";
            green = "#555555";
            yellow = "#4a4a4a";
            blue = "#5a5a5a";
            magenta = "#4f4f4f";
            cyan = "#464646";
            white = "#000000";
          };
          foreground = "#111111";
          background = "#f2f2f2";
          selectionFg = "#f2f2f2";
          selectionBg = "#3a3a3a";
          cursorText = "#f2f2f2";
          cursor = "#3a3a3a";
        };
      };
    };
  };
}
