{ pkgs, ... }:

let
  safeTorBrowser = pkgs.writeShellApplication {
    name = "safe-tor-browser";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
            set -eu

            tor_browser_app="/Applications/Tor Browser.app"

            mullvad_state() {
              if [ "''${SAFE_TOR_BROWSER_TEST_MODE:-0}" = "1" ]; then
                printf '%s\n' "''${SAFE_TOR_BROWSER_MULLVAD_STATE:-disconnected}"
                return 0
              fi

              if ! command -v mullvad >/dev/null 2>&1; then
                printf '%s\n' "missing"
                return 0
              fi

              mullvad status 2>/dev/null | tr '[:upper:]' '[:lower:]'
            }

            running_browsers() {
              if [ "''${SAFE_TOR_BROWSER_TEST_MODE:-0}" = "1" ]; then
                printf '%s\n' "''${SAFE_TOR_BROWSER_RUNNING_APPS:-}"
                return 0
              fi

              python3 <<'PY'
      import subprocess

      browsers = ["Safari", "Firefox", "Google Chrome", "Arc", "Brave Browser"]
      running = []
      for app in browsers:
          result = subprocess.run(["pgrep", "-x", app], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
          if result.returncode == 0:
              running.append(app)
      print(", ".join(running))
      PY
            }

            tor_installed() {
              if [ "''${SAFE_TOR_BROWSER_TEST_MODE:-0}" = "1" ]; then
                [ "''${SAFE_TOR_BROWSER_TOR_INSTALLED:-0}" = "1" ]
                return $?
              fi

              [ -d "$tor_browser_app" ]
            }

      state="$(mullvad_state)"
      case "$state" in
        connected*|*' connected'*) ;;
        *)
          printf '%s\n' "Mullvad VPN does not look connected. Connect Mullvad before opening Tor Browser." >&2
          exit 1
          ;;
      esac

            browsers="$(running_browsers)"
            if [ -n "$browsers" ]; then
              printf '%s\n' "Warning: close other browsers first when possible: $browsers" >&2
            fi

            if ! tor_installed; then
              printf '%s\n' "Tor Browser is not installed at $tor_browser_app. Rebuild nix-darwin to install the Homebrew cask." >&2
              exit 1
            fi

            printf '%s\n' "OPSEC: use Tor Browser for Tor only; do not mix identities or log into personal accounts."
            printf '%s\n' "OPSEC: keep downloads and uploads minimal, and assume the MacBook itself is not an anonymity boundary."
            printf '%s\n' "Launching Tor Browser..."

            if [ "''${SAFE_TOR_BROWSER_TEST_MODE:-0}" = "1" ]; then
              printf '%s\n' "Tor Browser launch simulated"
              exit 0
            fi

            open -a "$tor_browser_app"
    '';
  };
in
{
  home.packages = [ safeTorBrowser ];
}
