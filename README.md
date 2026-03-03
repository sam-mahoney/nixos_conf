# Helios NixOS Configuration

Modular NixOS configuration for the Helios laptop (Dell Precision 5570).

**Desktop:** Sway (Aerospace-inspired keybindings) · **Terminal:** Alacritty + tmux · **Theme:** Catppuccin Mocha

## 📁 Directory Structure

```
nixos-conf/
├── flake.nix                    # Main flake configuration
├── configuration.nix            # Main NixOS config
├── home.nix                     # Home Manager config
├── hardware-configuration.nix   # Auto-generated hardware config
│
├── modules/
│   ├── nixos/                   # System-level configuration modules
│   │   ├── boot.nix            # Bootloader and disk encryption
│   │   ├── networking.nix      # Network settings
│   │   ├── locale.nix          # Timezone and language
│   │   ├── desktop.nix         # Sway compositor and display manager
│   │   ├── hardware.nix        # Audio, printing, input devices
│   │   ├── users.nix           # User accounts and groups
│   │   ├── packages.nix        # System-wide packages and fonts
│   │   └── services.nix        # System services (SSH, Docker, TLP)
│   │
│   └── home-manager/           # User-level configuration modules
│       ├── packages.nix        # User packages and tools
│       ├── sway.nix            # Sway WM (Aerospace-style keybindings)
│       ├── waybar.nix          # Status bar
│       ├── swaylock.nix        # Screen locker configuration
│       ├── terminal.nix        # Alacritty terminal + Starship prompt
│       ├── tmux.nix            # Terminal multiplexer
│       ├── git.nix             # Git and SSH configuration
│       ├── services.nix        # User services (polkit agent)
│       └── battery-notifier.nix # Battery level notifications
│
└── [legacy files]              # Old configs (backup)
    ├── flake.nix.old
    ├── configuration.nix.old
    └── home.nix.old
```

## 🚀 Quick Start

### Applying Configuration

After editing any configuration files, rebuild the system:

```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake .#helios

# Test configuration without switching (boot into it once)
sudo nixos-rebuild test --flake .#helios

# Build configuration but only activate on next boot
sudo nixos-rebuild boot --flake .#helios
```

### Updating System

```bash
# Update all flake inputs (nixpkgs, home-manager, etc.)
nix flake update

# Update specific input only
nix flake lock --update-input nixpkgs

# Apply updates
sudo nixos-rebuild switch --flake .#helios
```

## 📝 Configuration Guide

### System Configuration (NixOS)

System-level settings are in `modules/nixos/`:

- **`boot.nix`** - Bootloader configuration and disk encryption
- **`networking.nix`** - Hostname, NetworkManager, proxy settings
- **`locale.nix`** - Timezone, language, and regional settings
- **`desktop.nix`** - Hyprland, GNOME, display manager, keyboard layout
- **`hardware.nix`** - Audio (PipeWire), printing (CUPS), touchpad
- **`users.nix`** - User accounts, groups, and permissions
- **`packages.nix`** - System-wide packages, fonts, and aliases
- **`services.nix`** - System services (SSH, Docker, TLP, firewall)

### User Configuration (Home Manager)

User-level settings are in `modules/home-manager/`:

- **`packages.nix`** - User packages (development tools, utilities, GUI apps)
- **`sway.nix`** - Sway window manager with Aerospace-style keybindings
- **`waybar.nix`** - Status bar appearance and modules
- **`swaylock.nix`** - Screen locker with blur effects
- **`terminal.nix`** - Alacritty terminal (auto-launches tmux)
- **`tmux.nix`** - Terminal multiplexer configuration
- **`git.nix`** - Git configuration with work/personal profiles
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
  neovim
];
```

### Sway Keybindings (Aerospace-style)

Keybindings are in `modules/home-manager/sway.nix`. The modifier is **Alt** (matching Aerospace on macOS):

| Key | Action |
|-----|--------|
| `Alt+Return` | Open terminal (Alacritty + tmux) |
| `Alt+d` | Application launcher (wofi) |
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

### Changing Waybar Appearance

Edit `modules/home-manager/waybar.nix`:

```nix
# Modify settings for module configuration
settings.mainBar.modules-right = [ ... ];

# Modify style for CSS styling
style = '' ... '';
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

Edit `modules/home-manager/git.nix`:

```nix
core.sshCommand = "ssh -i ~/.ssh/your_key";
```

## 🎨 Customization

### Sway Window Manager

Sway configuration in `modules/home-manager/sway.nix`:

- **Keybindings**: Aerospace-inspired (Alt modifier, hjkl navigation)
- **Gaps & Borders**: Minimal gaps with Catppuccin Mocha accent colors
- **Input**: GB keyboard, natural scroll touchpad, follow-mouse focus
- **Autostart**: waybar, mako, nm-applet, swayidle, wlsunset

### Waybar Status Bar

Waybar uses Catppuccin Mocha colors with Sway-native modules:

- **Modules**: sway/workspaces, sway/mode, sway/window, clock, CPU, memory, battery, network, audio
- **Styling**: Fully customizable CSS in the `style` section
- **Icons**: JetBrainsMono Nerd Font and Font Awesome

See `modules/home-manager/waybar.nix` for all available options.

## 🔍 Troubleshooting

### Configuration Errors

If rebuild fails, check syntax:
```bash
# Validate flake
nix flake check

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
- [Aerospace Guide](https://nikitabobko.github.io/AeroSpace/guide) (keybinding inspiration)
- [Nix Flakes](https://wiki.nixos.org/wiki/Flakes)

## ⚠️ Migration from Old Configuration

The old monolithic configuration files have been split into modules:

1. **Backup old files** (already done with `.bak` extension)
2. **Review new modular structure** in `modules/` directories
3. **Test new configuration** with `nixos-rebuild test`
4. **Switch to new configuration** when satisfied

To revert to old configuration, you can:
```bash
# Use git to restore old files
git checkout HEAD -- flake.nix configuration.nix home.nix
```

## 📋 Notes

- All configuration files have detailed inline comments
- Each module is self-contained and can be enabled/disabled by removing its import
- System uses NixOS 25.11 stable channel
- Home Manager is integrated into the flake for automatic deployment
- Hardware-specific optimizations from nixos-hardware are applied
