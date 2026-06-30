# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Deploy Commands

```bash
# NixOS rebuild (laptop / desktop)
sudo nixos-rebuild switch --flake .#helios
sudo nixos-rebuild switch --flake .#apollo

# macOS rebuild
darwin-rebuild switch --flake .#halcyon

# Test build without switching
sudo nixos-rebuild test --flake .#helios
darwin-rebuild build --flake .#halcyon

# Update flake inputs
nix flake update
nix flake lock --update-input nixpkgs
git diff flake.lock   # review changes before rebuilding

# Validate configuration
nix flake check

# Secret scan check
nix build .#checks.x86_64-linux.secret-scan

# Rollback
sudo nixos-rebuild switch --rollback

# Enable pre-commit hooks (gitleaks secret scanning)
git config core.hooksPath .githooks
```

## Architecture

This is a **Nix flakes** repository managing three machines with a shared module system:

- **helios** — Dell Precision 5570 laptop (NixOS, x86_64-linux)
- **apollo** — AMD 9950X desktop (NixOS, x86_64-linux, RTX 5080, gaming stack)
- **halcyon** — MacBook Pro 16 (nix-darwin, aarch64-darwin)

### Entrypoints

`flake.nix` defines two helper functions (`mkLinuxHost`, `mkDarwinHost`) that compose the system configurations. Each host has a root config file:

- `configuration.nix` -> helios, `configuration-apollo.nix` -> apollo (both import `configuration-common.nix`)
- `home.nix` -> Linux Home Manager, `home-darwin.nix` -> Darwin Home Manager (both import `modules/home-manager/common.nix`)

### Module Layout

- **`modules/theme.nix`** — Shared monochrome color palette. All UI modules import this; change a color once, it updates everywhere.
- **`modules/nixos/`** — NixOS system modules (boot, networking, desktop, hardware, services)
- **`modules/nixos/hosts/`** — Host-specific hardware (GPU drivers, kernel flags, LUKS encryption)
- **`modules/darwin/`** — nix-darwin system module and macOS defaults
- **`modules/home-manager/`** — User-level modules:
  - `common.nix` — baseline imports for all platforms (also inlines firefox and steampipe config)
  - Terminal: `alacritty.nix`, `zsh.nix` (shell + starship + direnv + fzf), `tmux.nix`
  - Editor: `neovim.nix`
  - Desktop: `sway.nix`, `kanshi.nix` (monitor profiles), `noctalia.nix`, `swaylock.nix`, `aerospace.nix`
  - Tools: `git.nix`, `opencode.nix`, `peon-ping.nix`, `packages.nix`

### Where to Add Packages

- **User-level (cross-platform):** `modules/home-manager/packages.nix` -> `sharedPackages` or `linuxOnlyPackages`
- **System-wide (Linux):** `modules/nixos/packages.nix` -> `environment.systemPackages`
- **macOS Homebrew casks:** `modules/darwin/system.nix` -> `homebrew.casks`
- **Neovim plugins:** `modules/home-manager/neovim.nix` -> `plugins`

### Overlays

- `opencodeOverlay` — pins opencode from nixos-unstable while rest uses stable
- `darwinBuildFixesOverlay` — fixes direnv compilation on Darwin

### Key Flake Inputs

nixpkgs (nixos-25.11), home-manager (release-25.11), nix-darwin (25.11), nixos-hardware, noctalia-shell, noctalia-qs, peon-ping, caveman, mac-app-util, firefox-addons

## Tests

Tests live in `tests/` as Nix derivations that assert configuration properties. They are evaluated as part of `nix flake check`. Currently: kernel param validation for helios GPU and Bluetooth stability.

## CI

GitHub Actions (`.github/workflows/secret-scan.yml`) runs gitleaks on PRs and pushes to master.

## Conventions

- **Theme**: All UI colors come from `modules/theme.nix`. Only swaylock uses its own palette (intentional noir accent).
- Host-specific hardware config goes in `modules/nixos/hosts/<hostname>.nix` or `modules/darwin/hosts/<hostname>.nix`
- Shared cross-platform Home Manager config goes through `modules/home-manager/common.nix`
- Wayland desktop packages (wl-clipboard, grim, slurp, swaylock, swayidle) are installed system-level in `modules/nixos/desktop.nix`, not in home-manager
- Alt-based keybindings are consistent between Sway (Linux) and AeroSpace (macOS)
- SSH keys are split work/personal with conditional git includes (see `modules/home-manager/git.nix`)

## Additional Docs

Detailed documentation lives in `docs/`:
- `where-to-edit.md` — "I want to change X" -> edit this file (comprehensive lookup table)
- `machines.md` — host-specific hardware details and quirks
- `keybinds.md` — all keybindings for Sway, AeroSpace, tmux, Neovim
- `neovim.md` — editor setup and keymaps
- `new-machine.md` — bootstrapping a fresh machine
