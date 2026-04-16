# Tor Browser on macOS

Tor Browser is installed as a Homebrew cask via nix-darwin. It lands at `/Applications/Tor Browser.app` after `darwin-rebuild switch --flake .#halcyon`.

## Usage

Always use `safe-tor-browser` instead of opening the app directly. It checks:

1. Mullvad is connected
2. No mainstream browsers (Safari, Firefox, Chrome, Arc, Brave) are running
3. Prints OPSEC reminders before launching

## Troubleshooting

**Tor Browser opens then immediately closes:**
- Run `/Applications/Tor Browser.app` directly once to see first-run dialogs or startup errors
- Check if Cold Turkey Blocker is running and has a rule matching Tor Browser

**Window management:** Tor Browser is set to float in AeroSpace (not tiled) to avoid startup interference.

## OPSEC basics

- Mullvad on before opening Tor Browser
- Close other browsers to avoid mixing sessions
- Don't log into personal accounts in Tor Browser
- Don't open downloaded files outside Tor Browser
- Treat the MacBook as a convenience endpoint, not a hardened anonymity setup
