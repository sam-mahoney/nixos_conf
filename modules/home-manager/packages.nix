{ config, pkgs, lib, ... }:

{
  # User-level packages installed via home-manager
  # These are installed per-user and don't require system-level permissions
  home.packages = with pkgs; [
    # === Utilities ===
    # Modern replacements for common Unix tools
    fd           # Faster find alternative
    ripgrep      # Faster grep alternative (rg)
    jq           # JSON processor and query tool
    fzf          # Fuzzy finder for command line
    eza          # Modern ls replacement with Git awareness
    dust         # Intuitive disk usage viewer
    
    # Compression and archiving tools
    zip          # Create .zip archives
    xz           # High-compression .xz format
    unzip        # Extract .zip archives
    zstd         # Fast compression algorithm
    gnutar       # GNU tar for .tar archives
    
    # === Network Tools ===
    # Diagnostic and testing utilities
    wget         # Non-interactive network downloader
    mtr          # Network diagnostic tool (traceroute + ping)
    iperf3       # Network bandwidth testing
    dnsutils     # DNS utilities (dig, nslookup)
    ldns         # Provides 'drill' command (dig replacement)
    nmap         # Network scanning and security auditing
    ipcalc       # IP address calculator
    termshark    # Terminal UI for Wireshark/tshark
    tor          # Privacy-focused overlay network client
    
    # === System Utilities ===
    # File and system information tools
    file         # Determine file type
    which        # Locate commands in PATH
    gnused       # GNU stream editor
    gawk         # GNU awk for text processing
    gnupg        # GPG encryption and signing
    nh           # Helper CLI for NixOS/Home Manager workflows
    nixfmt-rfc-style # Standard Nix formatter
    
    # === Terminal Tools ===
    # Enhanced terminal experience
    glow         # Render markdown beautifully in the terminal
    btop         # Modern resource monitor (top replacement)
    
    # === System Call Monitoring ===
    # Debugging and system analysis
    lsof         # List open files and network connections
    
    # === System Information ===
    # Hardware and system monitoring
    fastfetch    # System information display (neofetch alternative)
    
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
    ollama       # Local LLM runtime and model runner
    vscode       # Visual Studio Code editor
    gh           # GitHub command line tool
    opencode     # AI coding agent for the terminal
    # neovim is managed by programs.neovim in modules/home-manager/neovim.nix

    # === Language Servers (shared by opencode + neovim) ===
    nodePackages.typescript-language-server # TS/JS language server
    pyright                                # Python language server (default)
    basedpyright                            # Alternate Python language server
    gopls                                   # Go language server
    clang-tools                             # clangd for C/C++ language support
    nil                                     # Nix language server
    tree-sitter                             # Tree-sitter CLI/runtime
    ast-grep                                # AST-aware code search tool (sg)
    universal-ctags                         # Symbol indexing and tag generation

    # === Entertainment ===
    anki-bin          # Spaced repetition study app
    spotify           # Music streaming client

    # === Enterprise Communication ===
    # Work collaboration tools
    slack             # Team communication platform

    # === Password Manager ===
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    iotop                  # Monitor I/O usage by process
    iftop                  # Monitor network bandwidth by connection
    nvtopPackages.nvidia   # GPU monitoring for NVIDIA cards
    strace                 # Trace system calls and signals
    ltrace                 # Trace library calls
    sysstat                # Collection of performance monitoring tools
    lm_sensors             # Hardware monitoring (temperature, voltage)
    ethtool                # Network interface configuration
    pciutils               # PCI device utilities (lspci)
    usbutils               # USB device utilities (lsusb)
    teams-for-linux        # Microsoft Teams client for Linux
    _1password-gui         # 1Password desktop application
    _1password-cli         # 1Password CLI
    libnotify              # Library for desktop notifications (notify-send)
    wl-clipboard           # Command-line copy/paste for Wayland
    grim                   # Screenshot tool
    slurp                  # Region selection tool
    swaylock-effects       # Screen locker with blur effects
    swayidle               # Idle management daemon
    wlsunset               # Day/night gamma adjustments
    brightnessctl          # Backlight control
    imagemagick            # Required by Noctalia for template processing
    networkmanagerapplet   # Network configuration GUI (nm-applet)
    pavucontrol            # PulseAudio volume control
  ];

  programs.chromium = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    ];
  };

  xdg.mimeApps = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    defaultApplications = {
      "text/html" = [ "chromium-browser.desktop" "chromium.desktop" ];
      "application/xhtml+xml" = [ "chromium-browser.desktop" "chromium.desktop" ];
      "x-scheme-handler/http" = [ "chromium-browser.desktop" "chromium.desktop" ];
      "x-scheme-handler/https" = [ "chromium-browser.desktop" "chromium.desktop" ];
      "x-scheme-handler/about" = [ "chromium-browser.desktop" "chromium.desktop" ];
      "x-scheme-handler/unknown" = [ "chromium-browser.desktop" "chromium.desktop" ];
    };
  };
}
