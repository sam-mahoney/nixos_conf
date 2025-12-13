# Helios NixOS Configuration

Modular NixOS configuration for the Helios laptop (Dell Precision 5570).

## 📁 Directory Structure

```
nixos-conf/
├── flake.nix                    # Main flake configuration (NEW MODULAR VERSION)
├── configuration.nix            # Main NixOS config (NEW MODULAR VERSION)
├── home.nix                     # Home Manager config (NEW MODULAR VERSION)
├── hardware-configuration.nix   # Auto-generated hardware config
│
├── modules/
│   ├── nixos/                   # System-level configuration modules
│   │   ├── boot.nix            # Bootloader and disk encryption
│   │   ├── networking.nix      # Network settings
│   │   ├── locale.nix          # Timezone and language
│   │   ├── desktop.nix         # Desktop environment and display manager
│   │   ├── hardware.nix        # Audio, printing, input devices
│   │   ├── users.nix           # User accounts and groups
│   │   ├── packages.nix        # System-wide packages and fonts
│   │   └── services.nix        # System services (SSH, etc.)
│   │
│   └── home-manager/           # User-level configuration modules
│       ├── packages.nix        # User packages and tools
│       ├── hyprland.nix        # Hyprland window manager
│       ├── waybar.nix          # Status bar
│       ├── dunst.nix           # Notification daemon
│       ├── terminal.nix        # Terminal emulators and shell
│       ├── git.nix             # Git and SSH configuration
│       └── services.nix        # User services (polkit agent)
│
└── [legacy files]              # Old monolithic configs (backup)
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
- **`services.nix`** - System services like SSH, firewall rules

### User Configuration (Home Manager)

User-level settings are in `modules/home-manager/`:

- **`packages.nix`** - User packages (development tools, utilities, GUI apps)
- **`hyprland.nix`** - Hyprland window manager configuration and keybindings
- **`waybar.nix`** - Status bar appearance and modules
- **`dunst.nix`** - Notification daemon styling and behavior
- **`terminal.nix`** - Alacritty, Kitty, and Starship prompt
- **`git.nix`** - Git configuration with work/personal profiles
- **`services.nix`** - User services (polkit authentication agent)

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

### Modifying Hyprland Keybindings

Edit `modules/home-manager/hyprland.nix`:

```nix
bind = [
  # Add new keybinding
  "$mod, T, exec, kitty"  # Super+T opens Kitty terminal
];
```

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

### Hyprland Window Manager

Hyprland configuration uses a modular approach:
- **General settings**: gaps, borders, layouts
- **Animations**: bezier curves and transition effects
- **Keybindings**: workspace navigation, window management
- **Autostart**: programs launched on login

See `modules/home-manager/hyprland.nix` for detailed comments.

### Waybar Status Bar

Waybar uses Catppuccin-inspired colors:
- **Modules**: workspace, window, clock, CPU, memory, battery, network, audio
- **Styling**: Fully customizable CSS in the `style` section
- **Icons**: Nerd Font icons and Font Awesome

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
- [Hyprland Documentation](https://wiki.hyprland.org/)
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
