# Where to edit

Quick lookup. "I want to change X" -> edit this file.

## Theme and colors

| What | File |
|------|------|
| Monochrome palette (all UI) | `modules/theme.nix` |
| Swaylock lock screen colors | `modules/home-manager/swaylock.nix` (intentionally different — noir/blue accent) |

## Packages

| What | File |
|------|------|
| System-wide package (Linux) | `modules/nixos/packages.nix` |
| User package (cross-platform) | `modules/home-manager/packages.nix` |
| macOS Homebrew cask | `modules/darwin/system.nix` -> `homebrew.casks` |
| macOS Nix GUI app | `modules/darwin/system.nix` -> `nixGuiApps` |
| Neovim plugin | `modules/home-manager/neovim.nix` -> `plugins` |
| Firefox extension | Currently just enabled in `modules/home-manager/common.nix` |

## Desktop and window management

| What | File |
|------|------|
| Sway keybinds / layout | `modules/home-manager/sway.nix` |
| AeroSpace keybinds | `modules/home-manager/aerospace.nix` |
| Monitor profiles (kanshi) | `modules/home-manager/kanshi.nix` |
| Desktop shell (bar, notifications) | `modules/home-manager/noctalia.nix` |
| Lock screen appearance | `modules/home-manager/swaylock.nix` |
| Idle/suspend timeouts | `modules/home-manager/sway.nix` -> `startup` (swayidle command) |

## Terminal and editor

| What | File |
|------|------|
| Terminal appearance / font | `modules/home-manager/alacritty.nix` |
| Shell (zsh, aliases, completion) | `modules/home-manager/zsh.nix` |
| Shell prompt (Starship) | `modules/home-manager/zsh.nix` |
| tmux config | `modules/home-manager/tmux.nix` |
| Neovim (LSP, completion, theme) | `modules/home-manager/neovim.nix` |
| Neovim formatters (prettier, etc.) | `modules/home-manager/packages.nix` |

## Git and SSH

| What | File |
|------|------|
| Git identity / email | `modules/home-manager/git.nix` |
| SSH keys and host aliases | `modules/home-manager/git.nix` |
| Work vs personal split | `modules/home-manager/git.nix` -> `includes` and `matchBlocks` |

## System

| What | File |
|------|------|
| Boot / kernel (shared) | `modules/nixos/boot.nix` |
| Networking / hostname | `modules/nixos/networking.nix` |
| Audio / Bluetooth / printing | `modules/nixos/hardware.nix` |
| Docker / SSH / TLP | `modules/nixos/services.nix` |
| Users and groups | `modules/nixos/users.nix` |
| Timezone / locale | `modules/nixos/locale.nix` |
| Display manager (greetd) | `modules/nixos/desktop.nix` |

## Host-specific hardware

| What | File |
|------|------|
| Helios GPU / Bluetooth / LUKS / spd5118 | `modules/nixos/hosts/helios.nix` |
| Apollo GPU / NVIDIA drivers | `modules/nixos/hosts/apollo.nix` |
| Apollo gaming stack | `modules/nixos/hosts/apollo-gaming.nix` |
| Halcyon macOS defaults | `modules/darwin/system.nix` |
| Halcyon host identity | `modules/darwin/hosts/halcyon.nix` |

## AI tools

| What | File |
|------|------|
| OpenCode config / LSP / model | `modules/home-manager/opencode.nix` |
| Caveman style directive | `modules/home-manager/opencode.nix` -> `cavemanDirective` |
| Peon Ping (agent notifications) | `modules/home-manager/peon-ping.nix` |

## Flake inputs

| What | File |
|------|------|
| Pin nixpkgs / add inputs | `flake.nix` -> `inputs` |
| Lock versions | `flake.lock` (auto-managed by `nix flake update`) |
| Overlays | `flake.nix` -> `opencodeOverlay`, `darwinBuildFixesOverlay` |
