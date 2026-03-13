{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  firefoxDarwinPolicies = {
    EnterprisePoliciesEnabled = true;
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableFirefoxAccounts = true;
    DisableFirefoxScreenshots = true;
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    DontCheckDefaultBrowser = true;
    DisplayBookmarksToolbar = "never";
    DisplayMenuBar = "default-off";
    SearchBar = "unified";
    ExtensionSettings = {
      "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
        installation_mode = "force_installed";
      };
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
      };
    };
  };
in
{
  programs.firefox = {
    enable = true;

    # === Enterprise Policies ===
    # Applied via Nix wrapper on Linux, via macOS defaults on Darwin
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "default-off";
      SearchBar = "unified";

      # Force-install extensions from AMO
      ExtensionSettings = {
        # 1Password
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    # === Default Profile ===
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      extensions = {
        force = true;
        packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
        ];
      };

      # -- Search Engines --
      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        order = [
          "ddg"
          "google"
        ];
        engines = {
          "nix-packages" = {
            name = "Nix Packages";
            urls = [
              { template = "https://search.nixos.org/packages?query={searchTerms}"; }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "nixos-wiki" = {
            name = "NixOS Wiki";
            urls = [
              { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }
            ];
            definedAliases = [ "@nw" ];
          };
          "bing".metaData.hidden = true;
        };
      };

      # -- Preferences (user.js) --
      settings = {
        # --- Privacy & Telemetry ---
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

        # --- Disable Pocket ---
        "extensions.pocket.enabled" = false;
        "extensions.pocket.api" = "";
        "extensions.pocket.oAuthConsumerKey" = "";
        "extensions.pocket.showHome" = false;
        "extensions.pocket.site" = "";

        # --- Disable Firefox Accounts / Sync ---
        "identity.fxaccounts.enabled" = false;

        # --- Disable Sponsored Content ---
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";

        # --- Tracking Protection ---
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;

        # --- HTTPS-Only Mode ---
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;

        # --- Disable built-in password manager (use 1Password) ---
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.formlessCapture.enabled" = false;

        # --- Disable form autofill ---
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        # --- Quality of Life ---
        "browser.aboutConfig.showWarning" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.tabs.loadInBackground" = true;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.warnOnQuitShortcut" = false;
        "browser.download.useDownloadDir" = false;
        "browser.bookmarks.addedImportButton" = false;
        "general.smoothScroll" = true;
        "media.videocontrols.picture-in-picture.enabled" = true;

        # --- Auto-enable extensions (skip manual approval) ---
        "extensions.autoDisableScopes" = 0;

        # --- Enable userChrome.css customisation ---
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };

  # === 1Password Native Messaging Host (macOS only) ===
  # Homebrew-installed 1Password normally registers its manifest automatically.
  # If the extension cannot communicate with the desktop app, uncomment:
  # home.file."Library/Application Support/Mozilla/NativeMessagingHosts/com.1password.1password4.desktop.app.json" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  #   text = builtins.toJSON {
  #     name = "com.1password.1password4.desktop.app";
  #     description = "1Password";
  #     path = "/Applications/1Password.app/Contents/MacOS/1Password-KeyringHelper";
  #     type = "stdio";
  #     allowed_extensions = [ "{d634138d-c276-4fc8-924b-40a0ea21d284}" ];
  #   };
  # };

  targets.darwin.defaults = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    "org.nixos.firefox" = firefoxDarwinPolicies;
  };
}
