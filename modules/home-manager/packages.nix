{ config, pkgs, ... }:

{
  # User-level packages installed via home-manager
  # These are installed per-user and don't require system-level permissions
  home.packages = with pkgs; [
    # === Utilities ===
    # Modern replacements for common Unix tools
    ripgrep      # Faster grep alternative (rg)
    jq           # JSON processor and query tool
    fzf          # Fuzzy finder for command line
    
    # Compression and archiving tools
    zip          # Create .zip archives
    xz           # High-compression .xz format
    unzip        # Extract .zip archives
    zstd         # Fast compression algorithm
    gnutar       # GNU tar for .tar archives
    
    # === Network Tools ===
    # Diagnostic and testing utilities
    mtr          # Network diagnostic tool (traceroute + ping)
    iperf3       # Network bandwidth testing
    dnsutils     # DNS utilities (dig, nslookup)
    ldns         # Provides 'drill' command (dig replacement)
    nmap         # Network scanning and security auditing
    ipcalc       # IP address calculator
    
    # === System Utilities ===
    # File and system information tools
    file         # Determine file type
    which        # Locate commands in PATH
    gnused       # GNU stream editor
    gawk         # GNU awk for text processing
    gnupg        # GPG encryption and signing
    
    # === Terminal Tools ===
    # Enhanced terminal experience
    glow         # Render markdown beautifully in the terminal
    btop         # Modern resource monitor (top replacement)
    iotop        # Monitor I/O usage by process
    iftop        # Monitor network bandwidth by connection
    nvtopPackages.nvidia  # GPU monitoring for NVIDIA cards
    
    # === System Call Monitoring ===
    # Debugging and system analysis
    strace       # Trace system calls and signals
    ltrace       # Trace library calls
    lsof         # List open files and network connections
    
    # === System Information ===
    # Hardware and system monitoring
    fastfetch    # System information display (neofetch alternative)
    sysstat      # Collection of performance monitoring tools
    lm_sensors   # Hardware monitoring (temperature, voltage)
    ethtool      # Network interface configuration
    pciutils     # PCI device utilities (lspci)
    usbutils     # USB device utilities (lsusb)
    
    # === Python Development ===
    # Python interpreter and package management
    python313              # Python 3.13 interpreter
    python313Packages.pip  # Python package installer
    poetry                 # Python dependency management and packaging
    
    # === General Development ===
    # Cloud and DevOps tools
    awscli2      # AWS command line interface v2
    aws-vault    # Secure credential storage for AWS
    osv-scanner  # Vulnerability scanner for dependencies
    docker       # Container runtime and CLI
    vscode       # Visual Studio Code editor
    gh           # GitHub command line tool
    
    # === Enterprise Communication ===
    # Work collaboration tools
    slack             # Team communication platform
    teams-for-linux   # Microsoft Teams client for Linux
    
    # === Hyprland Ecosystem ===
    # Wayland compositor and related tools
    waybar                  # Status bar for Wayland compositors
    ashell                  # Application launcher for Wayland
    mako                    # Lightweight notification daemon
    libnotify               # Library for desktop notifications (notify-send)
    swww                    # Wallpaper daemon for Wayland
    wl-clipboard            # Command-line copy/paste for Wayland
    hyprpolkitagent         # Polkit authentication agent for Hyprland
    
    # System tray and control utilities
    networkmanagerapplet    # Network configuration GUI (nm-applet)
    pavucontrol             # PulseAudio volume control
  ];
}
