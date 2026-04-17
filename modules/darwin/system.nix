{ config, pkgs, ... }:

let
  user = "mahoney";
  nixGuiApps = with pkgs; [
    aerospace
    hidden-bar
    spotify
    discord
    logseq
    _1password-cli
  ];
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
  security.pam.services.sudo_local.reattach = true;

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

  environment.systemPackages = nixGuiApps;

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
      "hammerspoon"
      "maccy"
      "anytype"
      "mullvad-vpn"
      "tor-browser"
      "notion"
      "the-unarchiver"
      "balenaetcher"
      "1password"
      "little-snitch"
    ];
    taps = [ ];
    masApps = { };
  };

  # === Cleanup unwanted login items ===
  # Some apps self-register as login items; remove them on every rebuild
  system.activationScripts.postActivation.text = ''
    echo "removing unwanted login items..." >&2
    osascript -e 'tell application "System Events" to delete login item "Notion"' 2>/dev/null || true
    rm -f "$HOME/Library/LaunchAgents/com.valvesoftware.steamclean.plist" 2>/dev/null || true
  '';

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  system.stateVersion = 5;
}
