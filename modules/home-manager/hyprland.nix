{ config, pkgs, ... }:

{
  # Hyprland Wayland Compositor Configuration
  # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/
  
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;  # Enable X11 compatibility layer

    settings = {
      # Set modifier key to Super/Windows key
      "$mod" = "SUPER";
      
      # === Monitor Configuration ===
      # Format: monitor=name,resolution@refresh,position,scale
      # "preferred" uses the monitor's preferred resolution
      # "auto" automatically positions the monitor
      #
      # To position a monitor to the left of the laptop:
      # 1. Find monitor names with `hyprctl monitors` (e.g., eDP-1 for laptop, HDMI-A-1 for external)
      # 2. Configure them specifically. Specific rules must come before the generic one.
      monitor = [
        # External Monitor (Dell U2723QE) on the left
        "DP-2, 3840x2160@60, 0x0, 1"
        # Laptop Monitor (Sharp) on the right
        "eDP-1, 1920x1200@60, 3840x0, 1"
        
        ",preferred,auto,1"
      ];
      
      # === Autostart Applications ===
      # Programs to launch when Hyprland starts
      exec-once = [
        "waybar"      # Status bar
        "dunst"       # Notification daemon
        "nm-applet --indicator"  # Network manager system tray
        "swww-daemon"  # Wallpaper daemon
        "/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1"  # Authentication agent
        "hypridle"    # Idle management daemon
      ];

      # === Environment Variables ===
      # Set cursor size for X and Hyprland
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,Bibata-Modern-Ice"
      ];

      # === Input Configuration ===
      input = {
        kb_layout = "gb";  # British keyboard layout
        follow_mouse = 1;  # Focus follows mouse cursor
        sensitivity = 0;   # Use system pointer speed
        natural_scroll = true;  # Natural scrolling for mouse
        
        touchpad = {
          natural_scroll = true;  # Scroll direction matches finger movement
        };
      };

      # === General Appearance ===
      general = {
        gaps_in = 5;    # Gap size between windows
        gaps_out = 10;  # Gap size between windows and screen edge
        border_size = 2;
        
        # Active window border gradient (cyan to green)
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # Inactive window border (gray)
        "col.inactive_border" = "rgba(595959aa)";
        
        resize_on_border = false;  # Don't resize by dragging window borders
        allow_tearing = false;     # Disable screen tearing
        layout = "dwindle";        # Use dwindle layout algorithm
      };

      # === Decoration ===
      # Visual effects and styling
      decoration = {
        rounding = 10;  # Corner radius for windows
        
        # Window opacity
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        
        # Shadow settings
        "shadow:enabled" = true;
        "shadow:range" = 4;
        "shadow:render_power" = 3;
        "shadow:color" = "rgba(1a1a1aee)";
        
        # Blur settings
        "blur:enabled" = true;
        "blur:size" = 3;
        "blur:passes" = 1;
        "blur:vibrancy" = 0.1696;
      };

      # === Animations ===
      # Smooth transitions for window operations
      animations = {
        enabled = true;
        # Custom bezier curve for smooth animations
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        
        animation = [
          "windows, 1, 7, myBezier"              # Window open/close
          "windowsOut, 1, 7, default, popin 80%" # Window minimize
          "border, 1, 10, default"               # Border color change
          "borderangle, 1, 8, default"           # Border gradient rotation
          "fade, 1, 7, default"                  # Fade in/out
          "workspaces, 1, 6, default"            # Workspace switching
        ];
      };

      # === Dwindle Layout Configuration ===
      # Binary tree-based window tiling
      dwindle = {
        pseudotile = true;      # Enable pseudo-tiling
        preserve_split = true;  # Maintain split direction
      };

      # === Master Layout Configuration ===
      # Alternative layout with master-stack pattern
      master = {
        new_status = "master";  # New windows become master
      };

      # === Miscellaneous Settings ===
      misc = {
        force_default_wallpaper = 0;  # Don't force Hyprland wallpaper
        disable_hyprland_logo = true; # Hide Hyprland logo on empty workspace
      };

      # === Keybindings ===
      bind = [
        # --- Application Launchers ---
        "$mod, A, exec, alacritty"  # Terminal emulator
        "$mod, E, exec, thunar"     # File manager
        "$mod, R, exec, rofi -show drun"  # Application launcher
        "$mod, F, exec, firefox"    # Web browser
        "$mod, B, exec, brave"      # Alternative browser
        
        # --- Window Management ---
        "$mod, Q, killactive,"      # Close focused window
        "$mod, M, exit,"            # Exit Hyprland
        "$mod, V, togglefloating,"  # Toggle floating mode
        "$mod, P, pseudo,"          # Toggle pseudo-tiling
        "$mod, J, togglesplit,"     # Toggle split direction
        "$mod, F11, fullscreen, 0"  # Toggle fullscreen
        
        # --- Focus Movement (Arrow Keys) ---
        "$mod, left, movefocus, l"   # Focus left
        "$mod, right, movefocus, r"  # Focus right
        "$mod, up, movefocus, u"     # Focus up
        "$mod, down, movefocus, d"   # Focus down

        # --- Focus Movement (Vim Keys) ---
        "$mod, h, movefocus, l"  # Focus left
        "$mod, l, movefocus, r"  # Focus right
        "$mod, k, movefocus, u"  # Focus up
        "$mod, j, movefocus, d"  # Focus down

        # --- Window Movement (Arrow Keys) ---
        "$mod SHIFT, left, movewindow, l"   # Move window left
        "$mod SHIFT, right, movewindow, r"  # Move window right
        "$mod SHIFT, up, movewindow, u"     # Move window up
        "$mod SHIFT, down, movewindow, d"   # Move window down

        # --- Window Movement (Vim Keys) ---
        "$mod SHIFT, h, movewindow, l"  # Move window left
        "$mod SHIFT, l, movewindow, r"  # Move window right
        "$mod SHIFT, k, movewindow, u"  # Move window up
        "$mod SHIFT, j, movewindow, d"  # Move window down

        # --- Window Resizing (Arrow Keys) ---
        "$mod CTRL, left, resizeactive, -20 0"   # Shrink width
        "$mod CTRL, right, resizeactive, 20 0"   # Grow width
        "$mod CTRL, up, resizeactive, 0 -20"     # Shrink height
        "$mod CTRL, down, resizeactive, 0 20"    # Grow height

        # --- Window Resizing (Vim Keys) ---
        "$mod CTRL, h, resizeactive, -20 0"  # Shrink width
        "$mod CTRL, l, resizeactive, 20 0"   # Grow width
        "$mod CTRL, k, resizeactive, 0 -20"  # Shrink height
        "$mod CTRL, j, resizeactive, 0 20"   # Grow height

        # --- Special Workspace (Scratchpad) ---
        "$mod, S, togglespecialworkspace, magic"       # Toggle scratchpad visibility
        "$mod SHIFT, S, movetoworkspace, special:magic"  # Move window to scratchpad

        # --- Workspace Scrolling ---
        "$mod, mouse_down, workspace, e+1"  # Next workspace
        "$mod, mouse_up, workspace, e-1"    # Previous workspace

        # --- Screenshots ---
        ", Print, exec, grimblast copy area"     # Screenshot selection
        "SHIFT, Print, exec, grimblast copy screen"  # Screenshot full screen
        
        # --- Lock Screen ---
        "$mod, ESCAPE, exec, loginctl lock-session"   # Lock screen manually
      ] ++ (
        # --- Dynamic Workspace Bindings (1-9) ---
        # Generates keybindings for workspaces 1-9
        # $mod + [1-9] = Switch to workspace
        # $mod + SHIFT + [1-9] = Move window to workspace
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        ) 9)
      );

      # === Mouse Bindings ===
      # Hold modifier and use mouse to manipulate windows
      bindm = [
        "$mod, mouse:272, movewindow"    # Left click + drag to move
        "$mod, mouse:273, resizewindow"  # Right click + drag to resize
      ];

      # === Media Key Bindings (Hold to Repeat) ===
      # bindel = bind with repeat on hold
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"  # Volume up
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"  # Volume down
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"    # Brightness up
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"  # Brightness down
      ];

      # === Media Key Bindings (Toggle) ===
      # bindl = bind that works even when locked
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"  # Mute toggle
      ];

      # === Window Rules ===
      # Apply specific behaviors to certain windows
      windowrulev2 = [
        "suppressevent maximize, class:.*"  # Disable maximize event for all windows
        "float, class:(pavucontrol)"        # Float audio control window
        "float, class:(nm-connection-editor)"  # Float network manager window
      ];
    };
  };

  # === Environment Variables for Wayland ===
  # Enable Wayland support for Electron/Chromium applications
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # Export all systemd environment variables to Hyprland
  wayland.windowManager.hyprland.systemd.variables = ["--all"];
}
