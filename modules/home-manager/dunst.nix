{ config, pkgs, ... }:

{
  # Dunst - Lightweight notification daemon for Wayland/X11
  # Configuration reference: https://dunst-project.org/documentation/
  
  services.dunst = {
    enable = true;
    
    settings = {
      # === Global Configuration ===
      global = {
        # --- Display Settings ---
        monitor = 0;         # Show notifications on primary monitor
        follow = "mouse";    # Show notifications near mouse cursor
        
        # --- Geometry ---
        width = 300;         # Notification width
        height = 300;        # Maximum notification height
        origin = "top-right";  # Position notifications in top-right corner
        offset = "10x50";    # Offset from corner (x, y)
        scale = 0;           # UI scale factor (0 = auto)
        
        # --- Notification Limits ---
        notification_limit = 5;  # Maximum number of notifications shown at once
        
        # --- Progress Bar ---
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        
        # --- Behavior ---
        indicate_hidden = "yes";  # Show indicator if notifications are hidden
        transparency = 10;        # Background transparency (0-100)
        separator_height = 2;     # Height of separator between notifications
        gap_size = 0;             # Gap between notifications
        sort = "yes";             # Sort notifications by urgency
        
        # --- Padding and Spacing ---
        padding = 8;              # Vertical padding inside notification
        horizontal_padding = 8;   # Horizontal padding inside notification
        text_icon_padding = 0;    # Padding between text and icon
        
        # --- Visual Style ---
        frame_width = 2;          # Border width
        frame_color = "#89b4fa";  # Border color (blue)
        separator_color = "frame"; # Use frame color for separators
        
        # --- Text Formatting ---
        font = "JetBrainsMono Nerd Font 10";
        line_height = 0;          # Line spacing (0 = auto)
        markup = "full";          # Enable full HTML markup
        format = "<b>%s</b>\\n%b";  # Format: bold summary, normal body
        alignment = "left";       # Text alignment
        vertical_alignment = "center";
        ellipsize = "middle";     # Where to truncate long text
        ignore_newline = "no";    # Respect newlines in notifications
        
        # --- Icon Settings ---
        enable_recursive_icon_lookup = true;
        icon_position = "left";   # Show icon on left side
        min_icon_size = 32;       # Minimum icon size
        max_icon_size = 64;       # Maximum icon size
        
        # --- History and Interaction ---
        sticky_history = "yes";   # Keep notifications in history
        history_length = 20;      # Maximum notifications in history
        show_age_threshold = 60;  # Show age if older than N seconds
        show_indicators = "yes";  # Show indicators for actions/URLs
        
        # --- Advanced ---
        stack_duplicates = true;      # Group identical notifications
        hide_duplicate_count = false; # Show count of duplicates
        browser = "firefox";          # Browser for opening URLs
        always_run_script = true;     # Always run notification scripts
        
        # --- Mouse Actions ---
        mouse_left_click = "close_current";              # Left click closes notification
        mouse_middle_click = "do_action, close_current"; # Middle click performs action
        mouse_right_click = "close_all";                 # Right click closes all
      };
      
      # === Urgency Level: Low ===
      # For non-important notifications
      urgency_low = {
        background = "#1e1e2e";  # Dark background
        foreground = "#cdd6f4";  # Light text
        timeout = 5;             # Auto-dismiss after 5 seconds
      };
      
      # === Urgency Level: Normal ===
      # For standard notifications
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;            # Auto-dismiss after 10 seconds
      };
      
      # === Urgency Level: Critical ===
      # For important notifications that require attention
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#f38ba8";  # Red border for critical notifications
        timeout = 0;              # Don't auto-dismiss (manual close required)
      };
    };
  };
}
