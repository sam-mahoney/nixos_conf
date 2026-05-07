{
  config,
  pkgs,
  lib,
  ...
}:

let
  sharedPackages = with pkgs; [
    # Utilities
    bat
    fd
    ripgrep
    jq
    fzf
    eza
    dust
    zip
    xz
    unzip
    zstd
    gnutar

    # Network
    wget
    mtr
    iperf3
    dnsutils
    ldns
    nmap
    ipcalc
    termshark
    tor

    # System
    file
    which
    gnused
    gawk
    gnupg
    nh
    nixfmt-rfc-style
    stylua
    shfmt
    shellcheck
    typos

    # Terminal
    glow
    python313Packages.grip
    btop
    lsof
    fastfetch

    # Python
    python313
    python313Packages.pip
    poetry

    # Development
    awscli2
    aws-vault
    ansible
    steampipe
    osv-scanner
    docker
    ollama
    gh
    claude-code
    opencode

    # Language servers (shared by opencode + neovim)
    nodePackages.typescript-language-server
    pyright
    basedpyright
    gopls
    clang-tools
    nil
    marksman
    tree-sitter
    ast-grep
    universal-ctags
    vale
    nodePackages.prettier

    # Apps
    anki-bin
    slack
  ];

  # Packages only needed on Linux.
  # Wayland desktop tools (wl-clipboard, grim, slurp, swaylock-effects,
  # swayidle, brightnessctl) are installed system-level in desktop.nix
  # and nixos/packages.nix — not duplicated here.
  linuxOnlyPackages = with pkgs; [
    vscode
    spotify
    iotop
    iftop
    nvtopPackages.nvidia
    strace
    ltrace
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
    teams-for-linux
    _1password-gui
    _1password-cli
    libnotify
    wlsunset
    imagemagick
    networkmanagerapplet
    pavucontrol
    tigervnc
    wineWowPackages.stable
  ];
in

{
  home.packages = sharedPackages ++ lib.optionals pkgs.stdenv.isLinux linuxOnlyPackages;

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
      "text/html" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
    };
  };
}
