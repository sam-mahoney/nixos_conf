{ config, pkgs, ... }:

{
  # Waybar - Highly customizable status bar for Wayland compositors
  # Configuration reference: https://github.com/Alexays/Waybar/wiki
  
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        # === Bar Position and Layout ===
        layer = "top";      # Display on top layer
        position = "top";   # Position at top of screen
        height = 30;        # Bar height in pixels
        spacing = 4;        # Spacing between modules
        
        # === Module Placement ===
        # Left: Workspace and window information
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        # Center: Clock
        modules-center = ["clock"];
        # Right: System status indicators
        modules-right = ["pulseaudio" "network" "cpu" "memory" "temperature" "battery" "tray"];
        
        # === Workspace Module ===
        # Shows Hyprland workspaces
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            active = "";    # Icon for active workspace
            default = "";   # Icon for inactive workspace
          };
          # Always show 5 workspaces on all monitors
          persistent-workspaces = {
            "*" = 5;
          };
        };
        
        # === Window Title Module ===
        # Shows active window title
        "hyprland/window" = {
          format = "{}";
          max-length = 50;          # Truncate long titles
          separate-outputs = true;  # Show different titles per monitor
        };
        
        # === Clock Module ===
        # Time display with calendar tooltip
        clock = {
          interval = 1;  # Update every second
          format = "{:%H:%M:%S}";      # 24-hour format with seconds
          format-alt = "{:%Y-%m-%d}";  # Alternative: show date
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          
          # Calendar configuration
          calendar = {
            mode = "year";
            mode-mon-col = 3;      # Show 3 months per row
            weeks-pos = "right";   # Week numbers on right
            on-scroll = 1;         # Scroll to change month
            
            # Color scheme for calendar
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };
        
        # === CPU Module ===
        # Shows CPU usage percentage
        cpu = {
          format = " {usage}%";
          tooltip = false;
        };
        
        # === Memory Module ===
        # Shows RAM usage percentage
        memory = {
          format = " {}%";
        };
        
        # === Temperature Module ===
        # Shows system temperature with warning colors
        temperature = {
          critical-threshold = 80;  # Temperature in Celsius for critical state
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" ""];  # Icons for normal, warm, hot
        };
        
        # === Battery Module ===
        # Shows battery status and percentage
        battery = {
          states = {
            warning = 30;   # Warning level at 30%
            critical = 15;  # Critical level at 15%
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";     # Charging icon
          format-plugged = " {capacity}%";      # Plugged in icon
          format-alt = "{icon} {time}";          # Alternative: show time remaining
          format-icons = ["" "" "" "" ""];  # Battery level icons
        };
        
        # === Network Module ===
        # Shows network connection status
        network = {
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ipaddr}/{cidr}";
          tooltip-format = " {ifname} via {gwaddr}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        
        # === Audio Module ===
        # Shows volume and audio device
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = " {volume}%";       # Bluetooth audio
          format-bluetooth-muted = "  {volume}%";
          format-muted = " {volume}%";           # Muted state
          
          # Icons for different audio devices
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];  # Volume level icons
          };
          
          on-click = "pavucontrol";  # Open volume control on click
        };
        
        # === System Tray ===
        # Shows system tray icons
        tray = {
          spacing = 10;  # Spacing between tray icons
        };
      };
    };
    
    # === Waybar Styling (CSS) ===
    # Catppuccin-inspired color scheme
    style = ''
      /* === Base Styling === */
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
      }

      /* === Main Window === */
      window#waybar {
        background-color: rgba(26, 27, 38, 0.9);  /* Semi-transparent dark background */
        color: #cdd6f4;  /* Light text color */
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      /* === Workspace Buttons === */
      #workspaces button {
        padding: 0 5px;
        color: #7f849c;  /* Inactive workspace color */
        background-color: transparent;
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 0;
      }

      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.active {
        color: #89b4fa;  /* Active workspace color (blue) */
        background-color: transparent;
        box-shadow: inset 0 -3px #89b4fa;  /* Underline effect */
      }

      #workspaces button.urgent {
        background-color: #f38ba8;  /* Urgent workspace (red) */
      }

      /* === Module Base Styling === */
      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #tray,
      #mode,
      #window {
        padding: 0 10px;
        margin: 0 2px;
        background-color: transparent;
      }

      /* === Module-Specific Colors === */
      #window {
        color: #cdd6f4;  /* Window title */
      }

      #clock {
        color: #f9e2af;  /* Clock (yellow) */
      }

      #battery {
        color: #a6e3a1;  /* Battery (green) */
      }

      #battery.charging, #battery.plugged {
        color: #a6e3a1;
      }

      /* Battery critical state with blinking animation */
      #battery.critical:not(.charging) {
        background-color: #f38ba8;
        color: #1e1e2e;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      @keyframes blink {
        to {
          background-color: #f9e2af;
          color: #1e1e2e;
        }
      }

      #cpu {
        color: #89dceb;  /* CPU (cyan) */
      }

      #memory {
        color: #cba6f7;  /* Memory (purple) */
      }

      #temperature {
        color: #fab387;  /* Temperature (orange) */
      }

      #temperature.critical {
        background-color: #f38ba8;
        color: #1e1e2e;
      }

      #network {
        color: #94e2d5;  /* Network (teal) */
      }

      #network.disconnected {
        color: #f38ba8;  /* Disconnected (red) */
      }

      #pulseaudio {
        color: #f5c2e7;  /* Audio (pink) */
      }

      #pulseaudio.muted {
        color: #7f849c;  /* Muted (gray) */
      }

      #tray {
        color: #b4befe;  /* Tray (lavender) */
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #f38ba8;
      }
    '';
  };
}
