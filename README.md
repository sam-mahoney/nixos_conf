# Nix Configuration

NixOS and nix-darwin flake managing three machines:

| Host | Machine | OS | Notes |
|------|---------|-----|-------|
| `helios` | Dell Precision 5570 | NixOS (x86_64) | Laptop, Intel+NVIDIA hybrid GPU |
| `apollo` | AMD 9950X + RTX 5080 | NixOS (x86_64) | Desktop, gaming stack |
| `halcyon` | MacBook Pro 16 | nix-darwin (aarch64) | Homebrew integration |

Desktop: Sway (Linux) / AeroSpace (macOS). Terminal: Alacritty + tmux. Editor: Neovim. Theme: monochrome black/grey/white.

## Rebuild

```bash
# NixOS
sudo nixos-rebuild switch --flake .#helios
sudo nixos-rebuild switch --flake .#apollo

# macOS
darwin-rebuild switch --flake .#halcyon

# Test without switching
sudo nixos-rebuild test --flake .#helios

# Validate
nix flake check
```

## Update inputs

```bash
nix flake update                          # all inputs
nix flake lock --update-input nixpkgs     # single input
git diff flake.lock                       # review before rebuilding
```

## How it fits together

`flake.nix` defines `mkLinuxHost` and `mkDarwinHost` helper functions that compose each machine's config.

**System configs** (what gets built):
- `configuration.nix` → helios, `configuration-apollo.nix` → apollo — both import `configuration-common.nix` for shared NixOS settings
- Home Manager: `home.nix` (Linux) and `home-darwin.nix` (macOS) — both import `modules/home-manager/common.nix`

**Modules** (the building blocks):
- `modules/nixos/` — system-level: boot, networking, desktop (Sway + greetd), hardware (PipeWire, Bluetooth), services (Docker, SSH, TLP)
- `modules/nixos/hosts/` — per-machine hardware quirks (GPU drivers, kernel flags)
- `modules/darwin/` — macOS system defaults, Homebrew, keyboard remapping
- `modules/home-manager/` — user-level: editor, terminal, git, window manager, packages. Shared baseline in `common.nix`; Linux adds sway/noctalia/swaylock, macOS adds aerospace

**Overlays:**
- `opencodeOverlay` — pins opencode from nixos-unstable
- `darwinBuildFixesOverlay` — fixes direnv on Darwin

## Adding packages

System-wide (all users): edit `modules/nixos/packages.nix` → `environment.systemPackages`

User-level: edit `modules/home-manager/packages.nix` → `home.packages`

macOS Homebrew casks: edit `modules/darwin/system.nix` → `homebrew.casks`

## Tests

Tests live in `tests/` as Nix derivations that assert config properties. Run with `nix flake check`.

## Secret scanning

CI runs gitleaks on PRs via GitHub Actions. For local scanning:

```bash
git config core.hooksPath .githooks    # enable pre-commit hook
nix build .#checks.x86_64-linux.secret-scan  # run manually
```

## Rollback

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
sudo nixos-rebuild switch --rollback
```

## Other docs

All in `docs/`:

- [where-to-edit.md](docs/where-to-edit.md) — "I want to change X" → edit this file
- [machines.md](docs/machines.md) — host-specific hardware details and quirks
- [keybinds.md](docs/keybinds.md) — all keybindings for Sway, AeroSpace, tmux, Neovim
- [neovim.md](docs/neovim.md) — editor setup and keymaps
- [new-machine.md](docs/new-machine.md) — bootstrapping a fresh machine
- [tor-browser.md](docs/tor-browser.md) — Tor Browser workflow on macOS
