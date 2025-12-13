{ config, pkgs, ... }:

{
  # Hyprlock - Screen locker for Hyprland
  # Modern, GPU-accelerated lock screen with blur effects
  # https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/
  
  programs.hyprlock = {
    enable = true;
    
    settings = {
      # === General Configuration ===
      general = {
        disable_loading_bar = false;  # Show loading bar
        hide_cursor = true;           # Hide mouse cursor
        grace = 0;                    # No grace period (lock immediately)
        no_fade_in = false;           # Fade in animation
        no_fade_out = false;          # Fade out animation
      };
      
      # === Background ===
      background = [
        {
          monitor = "";  # Apply to all monitors
          path = "screenshot";  # Use screenshot of current desktop
          blur_passes = 3;      # Blur strength (0-10)
          blur_size = 7;        # Blur kernel size
          noise = 0.0117;       # Add slight noise for texture
          contrast = 0.8916;    # Reduce contrast
          brightness = 0.8172;  # Slightly dim
          vibrancy = 0.1696;    # Reduce color saturation
          vibrancy_darkness = 0.0;
        }
      ];
      
      # === Input Field ===
      input-field = [
        {
          monitor = "";  # Show on all monitors
          size = "300, 50";
          outline_thickness = 2;
          
          # Dots configuration
          dots_size = 0.33;     # Scale of dots
          dots_spacing = 0.15;  # Space between dots
          dots_center = true;   # Center the dots
          dots_rounding = -1;   # Fully round dots
          
          # Colors (Catppuccin-inspired)
          outer_color = "rgb(24, 24, 37)";      # Dark outer border
          inner_color = "rgb(30, 30, 46)";      # Dark background
          font_color = "rgb(205, 214, 244)";    # Light text
          check_color = "rgb(137, 180, 250)";   # Blue when checking
          fail_color = "rgb(243, 139, 168)";    # Red on failure
          
          # Text
          fade_on_empty = true;
          fade_timeout = 1000;  # Fade after 1 second
          placeholder_text = "<i>Enter password...</i>";
          hide_input = false;   # Show dots as you type
          
          rounding = 10;        # Rounded corners
          
          # Authentication failure settings
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";  # Show attempts
          fail_timeout = 2000;  # Show fail message for 2 seconds
          fail_transition = 300;  # Transition animation duration
          
          # Capslock indicator
          capslock_color = "rgb(249, 226, 175)";  # Yellow when caps lock on
          
          # Position (center of screen)
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
      ];
      
      # === Clock ===
      label = [
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%H:%M:%S")"'';  # Update every second
          color = "rgb(205, 214, 244)";
          font_size = 90;
          font_family = "JetBrainsMono Nerd Font";
          
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        
        # Date
        {
          monitor = "";
          text = ''cmd[update:3600000] echo "$(date +"%A, %d %B %Y")"'';  # Update every hour
          color = "rgb(205, 214, 244)";
          font_size = 25;
          font_family = "JetBrainsMono Nerd Font";
          
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        
        # User info
        {
          monitor = "";
          text = "Hi, $USER";
          color = "rgb(205, 214, 244)";
          font_size = 20;
          font_family = "JetBrainsMono Nerd Font";
          
          position = "0, 50";
          halign = "center";
          valign = "center";
        }
        
        # Battery status (for laptops)
        {
          monitor = "";
          text = ''cmd[update:10000] echo "$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo "")$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | grep -q Charging && echo " 󱐋" || echo " 󰁹")"'';
          color = "rgb(205, 214, 244)";
          font_size = 18;
          font_family = "JetBrainsMono Nerd Font";
          
          position = "30, -30";
          halign = "left";
          valign = "top";
        }
      ];
    };
  };
}
