{ pkgs, ... }:

let
  safeTorBrowser = pkgs.writeShellApplication {
    name = "safe-tor-browser";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.python3
    ];
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

      script = 'tell application "System Events"\n' \
               '  set browserNames to {"Safari", "Firefox", "Google Chrome", "Arc", "Brave Browser"}\n' \
               '  set runningBrowsers to {}\n' \
               '  repeat with browserName in browserNames\n' \
               '    if exists process (contents of browserName) then\n' \
               '      copy (contents of browserName) to end of runningBrowsers\n' \
               '    end if\n' \
               '  end repeat\n' \
               '  return runningBrowsers as string\n' \
               'end tell'

      result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
      if result.returncode == 0:
          raw = result.stdout.strip()
          if raw:
              names = [name.strip() for name in raw.replace(",", "\n").splitlines() if name.strip()]
          else:
              names = []
          print(", ".join(names))
      else:
          print("")
      PY
            }

            blocker_running() {
              if [ "''${SAFE_TOR_BROWSER_TEST_MODE:-0}" = "1" ]; then
                [ "''${SAFE_TOR_BROWSER_COLD_TURKEY_RUNNING:-0}" = "1" ]
                return $?
              fi

              pgrep -f "Cold Turkey Blocker" >/dev/null 2>&1
            }

            tor_running() {
              if [ "''${SAFE_TOR_BROWSER_TEST_MODE:-0}" = "1" ]; then
                [ "''${SAFE_TOR_BROWSER_TOR_RUNNING:-0}" = "1" ]
                return $?
              fi

              pgrep -f "Tor Browser" >/dev/null 2>&1
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

            if blocker_running; then
              printf '%s\n' "Warning: Cold Turkey Blocker is running and may terminate Tor Browser immediately if it has a matching block rule." >&2
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

            open "$tor_browser_app"

            sleep 2
            if ! tor_running; then
              printf '%s\n' "Tor Browser launched and then exited during startup. Try opening it once directly from /Applications/Tor Browser.app to surface any macOS or Tor Browser first-run dialogs." >&2
              exit 1
            fi
    '';
  };
in
{
  home.packages = [ safeTorBrowser ];
}
