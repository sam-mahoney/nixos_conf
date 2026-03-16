# Native macOS Tor Browser Workflow

This repo now treats native macOS Tor Browser usage as the pragmatic Tor workflow on `halcyon`.

## Install Path

Tor Browser is installed through nix-darwin's Homebrew integration as the `tor-browser` cask.

- Rebuild with `darwin-rebuild switch --flake .#halcyon`
- Homebrew places the app at `/Applications/Tor Browser.app`
- The launcher in this repo expects that path

This is the simplest honest macOS path here: Tor Browser is a normal macOS app, while the guardrails stay declarative in nix-darwin and Home Manager.

## Launcher

Use `safe-tor-browser` instead of opening Tor Browser directly.

It will:
- refuse to continue unless Mullvad looks connected
- warn if Safari, Firefox, Chrome, Arc, or Brave are already running
- print short OPSEC reminders
- launch `/Applications/Tor Browser.app`

## MacBook OPSEC

- Keep Mullvad connected before opening Tor Browser.
- Close mainstream browsers first so you do not casually mix habits, sessions, or copied links.
- Use Tor Browser only for Tor activity; do not log into personal accounts or reuse normal-browser identities.
- Treat the MacBook as a convenience endpoint, not a hardened anonymity boundary.
- Avoid opening downloaded files outside Tor Browser unless you are comfortable burning anonymity for that file.
- Keep the workflow simple: Mullvad on, other browsers closed if possible, Tor Browser only, then quit when done.
