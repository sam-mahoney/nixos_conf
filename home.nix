{ config, pkgs, ...}:

{
  home.username = "mahoney";
  home.homeDirectory = "/home/mahoney";

  home.packages = with pkgs; [
    # utils
    ripgrep
    jq
    zip
    xz
    unzip
    fzf
    
    # network tools
    mtr
    iperf3
    dnsutils
    ldns  # provides `drill` command, `dig` replacement
    nmap
    ipcalc

    # misc
    file
    which 
    gnused
    gnutar
    gawk
    zstd
    gnupg
    
    # term tools
    glow  # markdown in the terminal
    btop
    iotop
    iftop
    nvtopPackages.nvidia

    # system call stuff
    strace  # system call monitoring
    ltrace  # library call monitoring
    lsof  # list open files

    # system tools
    fastfetch
    sysstat
    lm_sensors
    ethtool
    pciutils  # lspci
    usbutils  # lsusb

    # python development
    python3
    poetry

    # general development
    awscli2
    osv-scanner
    docker
    vscode  

    # enterprise
    slack 
  
  ];

  programs.git = {
    enable = true;
    userName = "Sam Mahoney";
    userEmail = "mahoney@cmui.co.uk";  # default to personal

   extraConfig = {
     core.sshCommand = "ssh -i ~/.ssh/helios_personal_ed25519";
    };
  
  includes = [
    {
      # use work SSH key in work dir
      condition = "gitdir:~/cydar/";
      contents = {
        user = {
	  name = "Sam Mahoney";
          email = "sam.mahoney@cydar.co.uk";
        };
        core.sshCommand = "ssh -i ~/.ssh/helios_ed25519";
      };
    }
    ];
  };
  
  programs.starship = {
    enable = true;
  };

  programs.alacritty = {
    settings = {
      env.TERM = "xterm-256color";
      selection.save_to_clipboard = true;
    };
  };

  home.stateVersion = "25.11";
}
