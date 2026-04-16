# Where to edit

Quick lookup. "I want to change X" → edit this file.

## Packages

| What | File |
|------|------|
| System-wide package (Linux) | `modules/nixos/packages.nix` |
| User package (cross-platform) | `modules/home-manager/packages.nix` |
| macOS Homebrew cask | `modules/darwin/system.nix` → `homebrew.casks` |
| macOS Nix GUI app | `modules/darwin/system.nix` → `nixGuiApps` |
| Neovim plugin | `modules/home-manager/neovim.nix` → `plugins` |
| Firefox extension | `modules/home-manager/firefox.nix` |

## Desktop and window management

| What | File |
|------|------|
| Sway keybinds / layout | `modules/home-manager/sway.nix` |
| AeroSpace keybinds | `modules/home-manager/aerospace.nix` |
| Monitor profiles (kanshi) | `modules/home-manager/sway.nix` (bottom of file) |
| Desktop shell (bar, notifications) | `modules/home-manager/noctalia.nix` |
| Lock screen appearance | `modules/home-manager/swaylock.nix` |
| Idle/suspend timeouts | `modules/home-manager/sway.nix` → `startup` (swayidle command) |

## Terminal and editor

| What | File |
|------|------|
| Terminal appearance / font | `modules/home-manager/terminal.nix` |
| Shell prompt (Starship) | `modules/home-manager/terminal.nix` |
| tmux config | `modules/home-manager/tmux.nix` |
| Neovim (LSP, completion, theme) | `modules/home-manager/neovim.nix` |
| Neovim formatters (prettier, etc.) | `modules/home-manager/packages.nix` |

## Git and SSH

| What | File |
|------|------|
| Git identity / email | `modules/home-manager/git.nix` |
| SSH keys and host aliases | `modules/home-manager/git.nix` |
| Work vs personal split | `modules/home-manager/git.nix` → `includes` and `matchBlocks` |

## System

| What | File |
|------|------|
| Boot / encryption / kernel | `modules/nixos/boot.nix` |
| Networking / hostname | `modules/nixos/networking.nix` |
| Audio / Bluetooth / printing | `modules/nixos/hardware.nix` |
| Docker / SSH / TLP | `modules/nixos/services.nix` |
| Users and groups | `modules/nixos/users.nix` |
| Timezone / locale | `modules/nixos/locale.nix` |
| Display manager (greetd) | `modules/nixos/desktop.nix` |

## Host-specific hardware

| What | File |
|------|------|
| Helios GPU / Bluetooth quirks | `modules/nixos/hosts/helios.nix` |
| Apollo GPU / NVIDIA drivers | `modules/nixos/hosts/apollo.nix` |
| Apollo gaming stack | `modules/nixos/hosts/apollo-gaming.nix` |
| Halcyon macOS defaults | `modules/darwin/system.nix` |
| Halcyon host identity | `modules/darwin/hosts/halcyon.nix` |

## AI tools

| What | File |
|------|------|
| OpenCode config / LSP / model | `modules/home-manager/opencode.nix` |
| OpenCode AGENTS.md template | `modules/home-manager/opencode.nix` → `xdg.configFile` |
| Claude Code CLAUDE.md | `modules/home-manager/opencode.nix` → `xdg.configFile` |
| Peon Ping (agent notifications) | `modules/home-manager/opencode.nix` |
| Caveman (terse style plugin) | `modules/home-manager/opencode.nix` |

## Flake inputs

| What | File |
|------|------|
| Pin nixpkgs / add inputs | `flake.nix` → `inputs` |
| Lock versions | `flake.lock` (auto-managed by `nix flake update`) |
| Overlays | `flake.nix` → `opencodeOverlay`, `darwinBuildFixesOverlay` |
