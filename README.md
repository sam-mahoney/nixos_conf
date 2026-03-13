# Mahoney Nix Configuration

Mixed NixOS and nix-darwin configuration for multiple machines:

- `helios` — Dell Precision 5570 laptop
- `apollo` — desktop (AMD 9950X + NVIDIA RTX 5080, gaming stack with Steam + Heroic)
- `halcyon` — MacBook Pro 16 (nix-darwin + Homebrew + AeroSpace)

**Desktop:** Sway (Aerospace-inspired keybindings) · **Shell:** Noctalia (bar, notifications, OSD, launcher) · **Terminal:** Alacritty + tmux · **Theme:** Geohot-style monochrome (black/grey/white)

## 📁 Directory Structure

```
nixos-conf/
├── flake.nix                    # Main flake configuration
├── configuration.nix            # Main NixOS config (helios)
├── configuration-apollo.nix     # Main NixOS config (apollo)
├── home.nix                     # Linux Home Manager entrypoint
├── home-darwin.nix              # Darwin Home Manager entrypoint
├── hardware-configuration.nix   # Auto-generated hardware config
├── KEYBINDS.md                  # Full keybindings cheatsheet
│
├── modules/
│   ├── darwin/                  # macOS system-level configuration modules
│   │   ├── system.nix          # Shared nix-darwin settings + Homebrew
│   │   └── hosts/
│   │       └── halcyon.nix     # macOS host identity
│   │
│   ├── nixos/                   # System-level configuration modules
│   │   ├── boot.nix            # Bootloader and disk encryption
│   │   ├── networking.nix      # Network settings
│   │   ├── locale.nix          # Timezone and language
│   │   ├── desktop.nix         # Sway compositor and display manager
│   │   ├── hardware.nix        # Audio, Bluetooth, printing, input devices
│   │   ├── users.nix           # User accounts and groups
│   │   ├── packages.nix        # System-wide packages and fonts
│   │   └── services.nix        # System services (SSH, Docker, TLP, UPower)
│   │
│   └── home-manager/           # User-level configuration modules
│       ├── common.nix          # Shared Home Manager baseline for Linux + Darwin
│       ├── packages.nix        # User packages and tools
│       ├── aerospace.nix       # AeroSpace window manager config for macOS
│       ├── sway.nix            # Sway WM (Aerospace-style keybindings)
│       ├── noctalia.nix        # Noctalia desktop shell (bar, notifications, OSD, launcher)
│       ├── swaylock.nix        # Screen locker configuration
│       ├── terminal.nix        # Alacritty terminal + Starship prompt
│       ├── tmux.nix            # Terminal multiplexer
│       ├── git.nix             # Git and SSH configuration
│       ├── services.nix        # User services (polkit agent)
│       └── battery-notifier.nix # Battery level notifications
```

## 🚀 Quick Start

### Applying Configuration

After editing any configuration files, rebuild the system:

```bash
# Rebuild and switch laptop
sudo nixos-rebuild switch --flake .#helios

# Rebuild and switch desktop
sudo nixos-rebuild switch --flake .#apollo

# Test configuration without switching (boot into it once)
sudo nixos-rebuild test --flake .#helios

# Build configuration but only activate on next boot
sudo nixos-rebuild boot --flake .#helios

# Rebuild and switch macOS host
darwin-rebuild switch --flake .#halcyon

# Build macOS config without switching
nix build .#darwinConfigurations.halcyon.system
```

### Bootstrap a Fresh macOS Machine

```bash
# Install Determinate Systems Nix or official Nix first, then:
git clone <repo-url> ~/nixos-conf
cd ~/nixos-conf

# Apply nix-darwin system configuration
darwin-rebuild switch --flake .#halcyon
```

### First Migration From the Old Darwin Config

If `halcyon` is still on the older Darwin setup, do the first migration in two steps instead of switching blindly:

```bash
# 1) Confirm the Darwin target resolves
nix eval .#darwinConfigurations.halcyon.system --raw

# 2) Build without activating
darwin-rebuild build --flake .#halcyon

# 3) Inspect the built system and app outputs
ls -la ./result
ls -la ./result/sw/Applications

# 4) Only then activate
darwin-rebuild switch --flake .#halcyon

# 5) Verify Nix-managed apps showed up where expected
ls -la "/Applications/Nix Apps"
ls -la "$HOME/Applications/Home Manager Apps"
brew list --cask
```

For the first migration, Homebrew cleanup is intentionally set to `none` in `modules/darwin/system.nix` so old brew-managed apps are not aggressively removed during the initial cutover. Once the machine is stable, this can be tightened again.

### Updating System

```bash
# Update all flake inputs (nixpkgs, home-manager, etc.)
nix flake update

# Update specific input only
nix flake lock --update-input nixpkgs

# Apply updates
sudo nixos-rebuild switch --flake .#helios

# Apply updates on macOS
darwin-rebuild switch --flake .#halcyon
```

## 📝 Configuration Guide

### System Configuration (NixOS)

System-level settings are in `modules/nixos/`:

- **`boot.nix`** - Bootloader configuration and disk encryption
- **`networking.nix`** - Hostname, NetworkManager, proxy settings
- **`locale.nix`** - Timezone, language, and regional settings
- **`desktop.nix`** - Sway compositor, display manager (greetd), XDG portals
- **`hardware.nix`** - Audio (PipeWire), Bluetooth, printing (CUPS), touchpad
- **`users.nix`** - User accounts, groups, and permissions
- **`packages.nix`** - System-wide packages, fonts, and aliases
- **`services.nix`** - System services (SSH, Docker, TLP, UPower)

### User Configuration (Home Manager)

Shared user-level settings live in `modules/home-manager/common.nix` and `modules/home-manager/`, then each OS adds its own entrypoint:

- `home.nix` - Linux Home Manager entrypoint
- `home-darwin.nix` - Darwin Home Manager entrypoint
- `modules/home-manager/common.nix` - Shared shell/editor/git/package/OpenCode baseline

User-level modules are in `modules/home-manager/`:

- **`packages.nix`** - User packages (development tools, utilities, GUI apps)
- **`neovim.nix`** - Neovim with native LSP, completion, Telescope, formatting, and writing support
- **`aerospace.nix`** - AeroSpace config for macOS
- **`sway.nix`** - Sway window manager with Aerospace-style keybindings
- **`noctalia.nix`** - Desktop shell (bar, notifications, OSD, launcher)
- **`swaylock.nix`** - Screen locker with blur effects
- **`terminal.nix`** - Alacritty terminal (regular shells by default)
- **`tmux.nix`** - Terminal multiplexer configuration
- **`git.nix`** - Git and SSH configuration (with key caching)
- **`services.nix`** - User services (polkit authentication agent)
- **`battery-notifier.nix`** - Battery level notifications

## 🔧 Common Tasks

### Adding a New Package

**System-wide package** (available to all users):
```nix
# Edit modules/nixos/packages.nix
environment.systemPackages = with pkgs; [
  # Add your package here
  htop
];
```

**User package** (only for your user):
```nix
# Edit modules/home-manager/packages.nix
home.packages = with pkgs; [
  # Add your package here
  jq
];
```

### Neovim Setup

Neovim is configured in `modules/home-manager/neovim.nix` and supported by editor tooling in `modules/home-manager/packages.nix`.

See `NEOVIM.md` for the full setup guide, including plugins, language servers, formatting, writing support, keymaps, activation, and verification steps.

### Bootstrapping `AGENTS.md`

Use the shared template to create an `AGENTS.md` in any repo root:

```bash
./scripts/bootstrap-agents-md.sh /path/to/repo
```

If the target already has `AGENTS.md`, pass `--force` to replace it:

```bash
./scripts/bootstrap-agents-md.sh /path/to/repo --force
```

Template source: `AGENTS.template.md`
Bootstrap script: `scripts/bootstrap-agents-md.sh`

### Sway Keybindings (Aerospace-style)

Keybindings are in `modules/home-manager/sway.nix`. The modifier is **Alt** (matching Aerospace on macOS):

| Key | Action |
|-----|--------|
| `Alt+Return` | Open terminal (Alacritty + tmux) |
| `Alt+d` | Application launcher (Noctalia) |
| `Alt+q` | Close window |
| `Alt+h/j/k/l` | Focus left/down/up/right |
| `Alt+Shift+h/j/k/l` | Move window left/down/up/right |
| `Alt+1-9` | Switch to workspace 1-9 |
| `Alt+Shift+1-9` | Move window to workspace 1-9 |
| `Alt+/` | Toggle horizontal/vertical tiling |
| `Alt+,` | Toggle tabbed/stacking (accordion) |
| `Alt+f` | Fullscreen |
| `Alt+Shift+f` | Toggle floating |
| `Alt+Tab` | Workspace back-and-forth |
| `Alt+-/=` | Resize shrink/grow |
| `Alt+r` | Enter resize mode (hjkl to resize) |
| `Alt+Escape` | Lock screen |
| `Print` | Screenshot (full) |
| `Shift+Print` | Screenshot (region) |

### AeroSpace Keybindings (macOS)

AeroSpace config lives in `modules/home-manager/aerospace.nix` and keeps the same Alt-driven muscle memory as Linux:

| Key | Action |
|-----|--------|
| `Alt+Shift+Enter` | Open Alacritty |
| `Alt+Shift+b` | Open Firefox |
| `Alt+q` | Close window |
| `Alt+h/j/k/l` | Focus left/down/up/right |
| `Alt+Shift+h/j/k/l` | Move window left/down/up/right |
| `Alt+1-9` | Switch to workspace 1-9 |
| `Alt+Shift+1-9` | Move window to workspace 1-9 |
| `Alt+/` | Toggle horizontal/vertical tiling |
| `Alt+,` | Toggle horizontal/vertical tiling |
| `Alt+Tab` | Workspace back-and-forth |
| `Alt+Shift+;` | Enter service mode |

### tmux Keybindings

Prefix is **Ctrl+a** (more ergonomic than default Ctrl+b):

| Key | Action |
|-----|--------|
| `Ctrl+a \|` | Vertical split |
| `Ctrl+a -` | Horizontal split |
| `Ctrl+a h/j/k/l` | Navigate panes |
| `Ctrl+a c` | New window |
| `Ctrl+a 1-9` | Switch to window |
| `Ctrl+a d` | Detach session |

### Customising Noctalia Shell

Edit `modules/home-manager/noctalia.nix`:

```nix
# Configure bar widgets, position, and style
# Configure notification daemon, OSD, and app launcher
# See: https://github.com/noctalia-dev/noctalia-shell
```

### Adding a New User

Edit `modules/nixos/users.nix`:

```nix
users.users.newuser = {
  isNormalUser = true;
  extraGroups = [ "networkmanager" "wheel" ];
};
```

### Configuring SSH Keys

SSH keys are managed in `modules/home-manager/git.nix` with `programs.ssh`.
Keys are automatically cached by the SSH agent after first use (`addKeysToAgent = "yes"`).

## 🎨 Customization

### Sway Window Manager

Sway configuration in `modules/home-manager/sway.nix`:

- **Keybindings**: Aerospace-inspired (Alt modifier, hjkl navigation)
- **Gaps & Borders**: Minimal gaps with monochrome geohot-style accent colors
- **Input**: GB keyboard, natural scroll touchpad, follow-mouse focus
- **Autostart**: noctalia-shell, blueman-applet, mako, nm-applet, swayidle, wlsunset

### Noctalia Desktop Shell

Noctalia provides a unified desktop shell with:

- **Bar**: Workspaces, clock, network, Bluetooth, volume, battery, system tray
- **Notifications**: Built-in notification daemon with control centre (Alt+n / Alt+o)
- **OSD**: On-screen display for volume and brightness
- **Launcher**: Application launcher toggled with Alt+d

See `modules/home-manager/noctalia.nix` for configuration.

## 🔍 Troubleshooting

### Secret Scanning

This repo includes a `gitleaks`-based secret scanner through `flake check`.

```bash
# Run all flake checks (includes secret scan)
nix flake check

# Run only the secret scan check
nix build .#checks.x86_64-linux.secret-scan
```

To enable local pre-commit scanning for this repo:

```bash
# Use repository-managed hooks
git config core.hooksPath .githooks

# Optional: run the hook manually
.githooks/pre-commit
```

### Configuration Errors

If rebuild fails, check syntax:
```bash
# Validate flake
nix flake check

# Verify the Darwin host evaluates
nix eval .#darwinConfigurations.halcyon.system --raw --impure

# Show detailed error output
sudo nixos-rebuild switch --flake .#helios --show-trace
```

### Rollback to Previous Configuration

```bash
# List available generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Boot into specific generation
sudo nixos-rebuild switch --switch-generation <number>
```

### Home Manager Issues

```bash
# Rebuild only home-manager
home-manager switch --flake .#mahoney

# Check home-manager generations
home-manager generations
```

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [NixOS Options Search](https://search.nixos.org/options)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Sway Documentation](https://swaywm.org/)
- [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell) (desktop shell)
- [Aerospace Guide](https://nikitabobko.github.io/AeroSpace/guide) (keybinding inspiration)
- [Nix Flakes](https://wiki.nixos.org/wiki/Flakes)
- [OpenCode Tooling Plan](./OPENCODE-TOOLING.md) (tool rationale, testing, workflow)

## 📋 Notes

- All configuration files have detailed inline comments
- Each module is self-contained and can be enabled/disabled by removing its import
- System uses NixOS 25.11 stable channel
- Home Manager is integrated into the flake for automatic deployment
- Hardware-specific optimizations from nixos-hardware are applied
