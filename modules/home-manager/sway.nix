{
  config,
  pkgs,
  lib,
  ...
}:

let
  p = (import ../theme.nix).palette;
in
{
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod1"; # Alt key
      terminal = "alacritty";
      defaultWorkspace = "workspace number 1";

      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size = 11.0;
      };

      gaps = { inner = 0; outer = 0; };

      window = { titlebar = false; border = 2; };
      floating = { titlebar = false; border = 2; };

      colors = {
        focused = {
          border = p.gray1; background = p.bg; text = p.fg;
          indicator = p.gray1; childBorder = p.gray1;
        };
        focusedInactive = {
          border = p.gray3; background = p.bg; text = p.gray1;
          indicator = p.gray3; childBorder = p.gray3;
        };
        unfocused = {
          border = p.gray5; background = p.bg; text = p.gray3;
          indicator = p.gray5; childBorder = p.gray5;
        };
        urgent = {
          border = p.red; background = p.bg; text = p.fg;
          indicator = p.red; childBorder = p.red;
        };
      };

      output = { "*" = { bg = "${p.bg} solid_color"; }; };

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          repeat_delay = "300";
          repeat_rate = "50";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
          middle_emulation = "enabled";
        };
        "type:pointer" = {
          natural_scroll = "enabled";
        };
      };

      startup = [
        { command = "noctalia-shell"; }
        { command = "nm-applet --indicator"; }
        { command = "blueman-applet"; }
      ];

      window.commands = [
        { criteria = { app_id = "pavucontrol"; }; command = "floating enable"; }
        { criteria = { app_id = "nm-connection-editor"; }; command = "floating enable"; }
        { criteria = { app_id = "blueman-manager"; }; command = "floating enable"; }
        { criteria = { window_role = "pop-up"; }; command = "floating enable"; }
        { criteria = { window_role = "dialog"; }; command = "floating enable"; }
        { criteria = { window_type = "dialog"; }; command = "floating enable"; }
      ];

      assigns = {
        "9" = [
          { class = "Slack"; }
          { app_id = "Slack"; }
        ];
      };

      focus = { followMouse = true; wrapping = "yes"; };
      bars = [ ];

      keybindings =
        let mod = modifier;
        in {
          # Launchers
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Shift+b" = "exec firefox";
          "${mod}+d" = "exec noctalia-shell ipc call launcher toggle";

          # Window management
          "${mod}+q" = "kill";
          "${mod}+Shift+e" = "exec swaynag -t warning -m 'Exit Sway?' -B 'Yes' 'swaymsg exit'";
          "${mod}+Shift+c" = "reload";

          # Focus (vim-style)
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          # Move windows
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          # Layout
          "${mod}+slash" = "layout toggle splitv splith";
          "${mod}+comma" = "layout toggle tabbed stacking";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+Shift+f" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";
          "${mod}+b" = "splith";
          "${mod}+v" = "splitv";

          # Resize
          "${mod}+minus" = "resize shrink width 50 px";
          "${mod}+equal" = "resize grow width 50 px";
          "${mod}+Shift+minus" = "resize shrink height 50 px";
          "${mod}+Shift+equal" = "resize grow height 50 px";

          # Workspaces
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";

          # Move to workspace
          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";

          # Workspace navigation
          "${mod}+Tab" = "workspace back_and_forth";
          "${mod}+Shift+Tab" = "move container to workspace back_and_forth; workspace back_and_forth";

          # Multi-monitor
          "${mod}+period" = "focus output right";
          "${mod}+Shift+period" = "move workspace to output right";

          # Scratchpad
          "${mod}+s" = "scratchpad show";
          "${mod}+Shift+s" = "move scratchpad";

          # Screenshots
          "Print" = "exec grim - | wl-copy";
          "Shift+Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
          "${mod}+Print" = "exec grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";

          # Lock
          "${mod}+Escape" = "exec swaylock -f";

          # Media keys
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

          # Resize mode
          "${mod}+r" = "mode resize";

          # Noctalia shell panels
          "${mod}+n" = "exec noctalia-shell ipc call notifications toggleHistory";
          "${mod}+o" = "exec noctalia-shell ipc call controlCenter toggle";
          "${mod}+p" = "exec noctalia-shell ipc call sessionMenu toggle";
        };

      modes = {
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

    extraConfig = ''
      seat seat0 xcursor_theme Bibata-Modern-Ice 24
      default_border pixel 2
      gaps top 2
    '';
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_DESKTOP = "sway";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
