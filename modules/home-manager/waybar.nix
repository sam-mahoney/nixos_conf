{ config, pkgs, ... }:

{
  # Waybar - Highly customizable status bar for Wayland compositors
  # Configured for Sway — uses sway/workspaces and sway/window modules
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
        modules-left = ["sway/workspaces" "sway/mode" "sway/window"];
        # Center: Clock
        modules-center = ["clock"];
        # Right: System status indicators
        modules-right = ["pulseaudio" "network" "cpu" "memory" "temperature" "battery" "tray"];
        
        # === Workspace Module (Sway) ===
        "sway/workspaces" = {
          disable-scroll = false;
          all-outputs = false;
          format = "{name}";
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
        };

        # === Sway Mode Module ===
        # Shows active binding mode (e.g. "resize")
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        
        # === Window Title Module (Sway) ===
        "sway/window" = {
          format = "{}";
          max-length = 50;          # Truncate long titles
          separate-outputs = true;  # Show different titles per monitor
        };
        
        # === Clock Module ===
        clock = {
          interval = 1;
          format = "{:%H:%M:%S}";
          format-alt = "{:%A, %d %B %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            
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
        cpu = {
          format = " {usage}%";
          tooltip = false;
        };
        
        # === Memory Module ===
        memory = {
          format = " {}%";
        };
        
        # === Temperature Module ===
        temperature = {
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" ""];
        };
        
        # === Battery Module ===
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["" "" "" "" ""];
        };
        
        # === Network Module ===
        network = {
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ipaddr}/{cidr}";
          tooltip-format = " {ifname} via {gwaddr}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        
        # === Audio Module ===
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = " {volume}%";
          format-bluetooth-muted = "  {volume}%";
          format-muted = " {volume}%";
          
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          
          on-click = "pavucontrol";
        };
        
        # === System Tray ===
        tray = {
          spacing = 10;
        };
      };
    };
    
    # === Waybar Styling (CSS) ===
    # Catppuccin Mocha color scheme
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
        background-color: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      /* === Workspace Buttons === */
      #workspaces button {
        padding: 0 8px;
        color: #7f849c;
        background-color: transparent;
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 0;
      }

      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.focused {
        color: #89b4fa;
        background-color: transparent;
        box-shadow: inset 0 -3px #89b4fa;
      }

      #workspaces button.urgent {
        background-color: #f38ba8;
      }

      /* === Sway Mode Indicator === */
      #mode {
        padding: 0 10px;
        background-color: #f38ba8;
        color: #1e1e2e;
        font-weight: bold;
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
        color: #cdd6f4;
      }

      #clock {
        color: #f9e2af;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.charging, #battery.plugged {
        color: #a6e3a1;
      }

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
        color: #89dceb;
      }

      #memory {
        color: #cba6f7;
      }

      #temperature {
        color: #fab387;
      }

      #temperature.critical {
        background-color: #f38ba8;
        color: #1e1e2e;
      }

      #network {
        color: #94e2d5;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #pulseaudio {
        color: #f5c2e7;
      }

      #pulseaudio.muted {
        color: #7f849c;
      }

      #tray {
        color: #b4befe;
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
