{
  config,
  pkgs,
  lib,
  ...
}:

{
  # === Sway Wayland Compositor Configuration ===
  # Aerospace-inspired tiling window manager for Linux
  # Keybindings mirror Aerospace defaults: Alt as modifier, hjkl navigation
  #
  # Key philosophy from Aerospace:
  #   - Alt (Mod1) as the primary modifier (like Aerospace on macOS)
  #   - hjkl for directional focus/move (vim-style)
  #   - Alt+number for workspace switching
  #   - Binding modes for resize and service operations
  #   - Clean gaps and minimal chrome

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fix GTK apps

    config = rec {
      # === Modifier Key ===
      # Alt key — matches Aerospace's default modifier
      modifier = "Mod1";

      # === Terminal ===
      # Alacritty launches tmux automatically (see terminal.nix)
      terminal = "alacritty";

      # === Application Launcher ===
      # Noctalia shell provides the launcher (Alt+d toggles it via IPC)

      # === Default Layout ===
      # Tabbed by default (similar to Aerospace's accordion layout)
      # You can toggle between layouts with Alt+/
      defaultWorkspace = "workspace number 1";

      # === Font ===
      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size = 11.0;
      };

      # === Gaps (Aerospace-style) ===
      gaps = {
        inner = 2;
        outer = 0;
      };

      # === Window Borders ===
      window = {
        titlebar = false;
        border = 1;
      };

      floating = {
        titlebar = false;
        border = 1;
      };

      # === Colors (aligned with terminal + Noctalia palette) ===
      colors = {
        focused = {
          border = "#c0c0c0";
          background = "#000000";
          text = "#d8d8d8";
          indicator = "#c0c0c0";
          childBorder = "#c0c0c0";
        };
        focusedInactive = {
          border = "#9a9a9a";
          background = "#000000";
          text = "#c0c0c0";
          indicator = "#9a9a9a";
          childBorder = "#9a9a9a";
        };
        unfocused = {
          border = "#3a3a3a";
          background = "#000000";
          text = "#9a9a9a";
          indicator = "#3a3a3a";
          childBorder = "#3a3a3a";
        };
        urgent = {
          border = "#ff8080";
          background = "#000000";
          text = "#d8d8d8";
          indicator = "#ff8080";
          childBorder = "#ff8080";
        };
      };

      # === Monitor Configuration ===
      output = {
        "*" = {
          bg = "#000000 solid_color";
        };
      };

      # === Input Configuration ===
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          repeat_delay = "300";
          repeat_rate = "50";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled"; # Disable while typing
          middle_emulation = "enabled";
        };
        "type:pointer" = {
          natural_scroll = "enabled";
        };
      };

      # === Startup Applications ===
      startup = [
        { command = "noctalia-shell"; } # Desktop shell (bar, notifications, OSD, notifications)
        { command = "nm-applet --indicator"; }
        { command = "blueman-applet"; } # Bluetooth tray applet
        {
          command = "systemctl --user restart kanshi.service";
          always = true;
        }
        {
          command = "swayidle -w timeout 120 'brightnessctl set 10%' resume 'brightnessctl set 50%' timeout 300 'swaylock -f' timeout 360 'swaymsg \"output * power off\"' resume 'swaymsg \"output * power on\"' timeout 600 'systemctl suspend' before-sleep 'swaylock -f'";
        }
        # Keep startup lean: no gamma daemon by default
      ];

      # === Window Rules ===
      window.commands = [
        {
          criteria = {
            app_id = "pavucontrol";
          };
          command = "floating enable";
        }
        {
          criteria = {
            app_id = "nm-connection-editor";
          };
          command = "floating enable";
        }
        {
          criteria = {
            app_id = "blueman-manager";
          };
          command = "floating enable";
        }
        {
          criteria = {
            window_role = "pop-up";
          };
          command = "floating enable";
        }
        {
          criteria = {
            window_role = "dialog";
          };
          command = "floating enable";
        }
        {
          criteria = {
            window_type = "dialog";
          };
          command = "floating enable";
        }
      ];

      # === Workspace Assignments ===
      # Automatically move apps to specific workspaces when they open
      assigns = {
        "9" = [
          { class = "Slack"; } # XWayland
          { app_id = "Slack"; } # Wayland-native
        ];
      };

      # === Focus Behaviour ===
      focus = {
        followMouse = true;
        wrapping = "yes";
      };

      # === Bar (disabled — using Noctalia shell) ===
      bars = [ ];

      # === Keybindings ===
      # Aerospace-style: Alt as modifier, hjkl for directions
      keybindings =
        let
          mod = modifier;
        in
        {
          # --- Application Launchers ---
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+d" = "exec noctalia-shell ipc call launcher toggle"; # Noctalia launcher

          # --- Window Management ---
          "${mod}+q" = "kill";
          "${mod}+Shift+e" = "exec swaynag -t warning -m 'Exit Sway?' -B 'Yes' 'swaymsg exit'";
          "${mod}+Shift+c" = "reload";

          # --- Focus Movement (Aerospace-style: Alt+hjkl) ---
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          # --- Move Windows (Aerospace-style: Alt+Shift+hjkl) ---
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          # --- Layout Switching (Aerospace-style) ---
          # Alt+/ toggles between horizontal and vertical tiling (like Aerospace alt-slash)
          "${mod}+slash" = "layout toggle splitv splith";
          # Alt+, toggles tabbed/stacking (like Aerospace accordion)
          "${mod}+comma" = "layout toggle tabbed stacking";
          # Alt+f for fullscreen
          "${mod}+f" = "fullscreen toggle";
          # Alt+Shift+f for floating toggle (like Aerospace service mode 'f')
          "${mod}+Shift+f" = "floating toggle";
          # Alt+space to toggle focus between tiling/floating
          "${mod}+space" = "focus mode_toggle";

          # --- Split Direction ---
          "${mod}+b" = "splith"; # Horizontal split
          "${mod}+v" = "splitv"; # Vertical split

          # --- Resize (Aerospace-style: Alt+minus/equal) ---
          "${mod}+minus" = "resize shrink width 50 px";
          "${mod}+equal" = "resize grow width 50 px";
          "${mod}+Shift+minus" = "resize shrink height 50 px";
          "${mod}+Shift+equal" = "resize grow height 50 px";

          # --- Workspaces (Aerospace-style: Alt+number) ---
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";

          # --- Move Window to Workspace (Aerospace-style: Alt+Shift+number) ---
          "${mod}+Shift+1" = "move container to workspace number 1; workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2; workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3; workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4; workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5; workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6; workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7; workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8; workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9; workspace number 9";

          # --- Workspace Back-and-Forth (Aerospace-style: Alt+Tab) ---
          "${mod}+Tab" = "workspace back_and_forth";
          "${mod}+Shift+Tab" = "move container to workspace back_and_forth; workspace back_and_forth";

          # --- Multi-Monitor (Aerospace-style) ---
          "${mod}+period" = "focus output right";
          "${mod}+Shift+period" = "move workspace to output right";

          # --- Scratchpad (similar to Aerospace special workspace) ---
          "${mod}+s" = "scratchpad show";
          "${mod}+Shift+s" = "move scratchpad";

          # --- Screenshots ---
          "Print" = "exec grim - | wl-copy"; # Full screenshot
          "Shift+Print" = "exec grim -g \"$(slurp)\" - | wl-copy"; # Region screenshot
          "${mod}+Print" = "exec grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"; # Save to file

          # --- Screen Lock ---
          "${mod}+Escape" = "exec swaylock -f";

          # --- Volume & Brightness ---
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

          # --- Enter Resize Mode (Aerospace-style: Alt+Shift+semicolon for service mode) ---
          "${mod}+r" = "mode resize";

          # --- Noctalia Shell IPC ---
          # These trigger noctalia-shell panels via IPC
          # See: https://docs.noctalia.dev/getting-started/keybinds/
          "${mod}+n" = "exec noctalia-shell ipc call notifications toggleHistory";
          "${mod}+o" = "exec noctalia-shell ipc call controlCenter toggle";
          "${mod}+p" = "exec noctalia-shell ipc call sessionMenu toggle";
        };

      # === Binding Modes ===
      modes = {
        # Resize mode (like Aerospace's resize with hjkl)
        resize = {
          "h" = "resize shrink width 50 px";
          "j" = "resize grow height 50 px";
          "k" = "resize shrink height 50 px";
          "l" = "resize grow width 50 px";
          "Left" = "resize shrink width 50 px";
          "Down" = "resize grow height 50 px";
          "Up" = "resize shrink height 50 px";
          "Right" = "resize grow width 50 px";
          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };
    };

    # === Extra Config ===
    # Raw sway config appended at the end
    extraConfig = ''
      # Disable XWayland (pure Wayland — re-enable if you need X11 apps)
      # xwayland disable

      # Cursor theme
      seat seat0 xcursor_theme Bibata-Modern-Ice 24
    '';
  };

  # === Environment Variables for Wayland ===
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Electron/Chromium Wayland support
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";
    MOZ_ENABLE_WAYLAND = "1";
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "sway-session.target";
    settings = [
      {
        profile.name = "laptop";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1200@59.950Hz";
            position = "0,0";
          }
        ];
      }
      {
        profile.name = "docked-open";
        # Kanshi exec hooks are shell-split in a way that made the lid guard
        # unstable across restarts, so keep this profile match purely output-based.
        profile.exec = [ ];
        profile.outputs = [
          {
            criteria = "LG Electronics LG ULTRAFINE 412NTKF3S797";
            status = "enable";
            mode = "3840x2160@59.997Hz";
            transform = "90";
            position = "0,0";
          }
          {
            criteria = "Dell Inc. DELL U2723QE 9P79FH3";
            status = "enable";
            mode = "3840x2160@59.997Hz";
            position = "2160,0";
          }
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1200@59.950Hz";
            position = "3120,2160";
          }
        ];
      }
      {
        profile.name = "docked-closed";
        profile.outputs = [
          {
            criteria = "LG Electronics LG ULTRAFINE 412NTKF3S797";
            status = "enable";
            mode = "3840x2160@59.997Hz";
            transform = "90";
            position = "0,0";
          }
          {
            criteria = "Dell Inc. DELL U2723QE 9P79FH3";
            status = "enable";
            mode = "3840x2160@59.997Hz";
            position = "2160,0";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
        # Keep this profile output-driven as well; the previous shell guard broke
        # profile reloads and left the layout in a bad state.
        profile.exec = [ ];
      }
    ];
  };
}
