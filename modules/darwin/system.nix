{ config, pkgs, ... }:

let
  user = "mahoney";
in
{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = "nix-command flakes";
    warn-dirty = false;
  };

  nix.package = pkgs.nix;
  nix.optimise.automatic = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = user;
  system.startup.chime = false;
  system.keyboard = {
    remapCapsLockToEscape = true;
    enableKeyMapping = true;
    userKeyMapping = [
      {
        HIDKeyboardModifierMappingDst = 30064771125;
        HIDKeyboardModifierMappingSrc = 30064771172;
      }
    ];
  };

  system.defaults = {
    CustomUserPreferences = {
      NSGlobalDomain."com.apple.mouse.linear" = true;
    };

    menuExtraClock = {
      IsAnalog = true;
      ShowDate = 0;
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      PMPrintingExpandedStateForPrint = true;
    };

    LaunchServices.LSQuarantine = false;

    trackpad = {
      TrackpadRightClick = true;
      Clicking = true;
    };

    finder = {
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "clmv";
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
    };

    dock = {
      autohide = true;
      orientation = "left";
      autohide-delay = 0.15;
      expose-animation-duration = 0.15;
      show-recents = false;
      showhidden = true;
      persistent-apps = [ ];
      tilesize = 56;
      expose-group-apps = true;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };

    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = true;
      Display = true;
      NowPlaying = false;
      Sound = true;
    };

    spaces.spans-displays = true;

    screencapture = {
      location = "/Users/${user}/Downloads/screencaps";
      type = "png";
      disable-shadow = true;
    };

    WindowManager.EnableStandardClickToShowDesktop = false;
    screensaver.askForPassword = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.blex-mono
    nerd-fonts.departure-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
  ];

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    brews = [
      "mas"
      "wimlib"
    ];
    casks = [
      "1password"
      "hammerspoon"
      "logseq"
      "anytype"
      "notion"
      "firefox"
      "spotify"
      "the-unarchiver"
      "nikitabobko/tap/aerospace"
      "balenaetcher"
      "cold-turkey-blocker"
      "discord"
      "transmission"
      "mullvad-vpn"
    ];
    taps = [
      "nikitabobko/tap"
    ];
    masApps = { };
  };

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  system.stateVersion = 5;
}
