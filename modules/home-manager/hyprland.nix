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
        ",preferred,auto,1"
      ];
      
      # === Autostart Applications ===
      # Programs to launch when Hyprland starts
      exec-once = [
        "waybar"      # Status bar
        "mako"        # Notification daemon
        "nm-applet --indicator"  # Network manager system tray
        "swww-daemon"  # Wallpaper daemon
        "hyprpolkitagent"  # Authentication agent
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
        # Application launcher
        "$mod, R, exec, ashell"  # Application launcher
        
        # Window management
        "$mod, Q, killactive,"      # Close focused window
        "$mod, M, exit,"            # Exit Hyprland
        "$mod, V, togglefloating,"  # Toggle floating mode
        "$mod, P, pseudo,"          # Toggle pseudo-tiling
        "$mod, J, togglesplit,"     # Toggle split direction
        
        # Focus movement
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        
        # Special workspace
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        
        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ] ++ (
        # Workspace bindings (1-10)
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        ) 9)
      );

      # === Mouse Bindings ===
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
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
