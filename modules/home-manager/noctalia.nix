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
        density = "default";
        showCapsule = true;
        backgroundOpacity = 0.93;
        floating = false;

        widgets = {
          left = [
            {
              id = "Launcher";
            }
            {
              id = "Workspace";
              hideUnoccupied = false;
              labelMode = "number";
            }
          ];
          center = [
            {
              id = "Clock";
              formatHorizontal = "HH:mm  ·  ddd dd MMM";
              usePrimaryColor = true;
              useMonospacedFont = true;
            }
          ];
          right = [
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Volume";
            }
            {
              id = "Battery";
              alwaysShowPercentage = true;
              warningThreshold = 30;
            }
            {
              id = "Tray";
            }
          ];
        };
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
  };
}
