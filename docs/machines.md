# Machines

Hardware-specific details and quirks for each host. The stuff you need to know that isn't obvious from reading `flake.nix`.

## helios — Dell Precision 5570 laptop

Config: `modules/nixos/hosts/helios.nix`

**GPU:** Intel + NVIDIA hybrid. The nixos-hardware module for this laptop tries to use the `xe` driver for device `46a6`, but that breaks external displays. The config forces `i915` instead and explicitly blocks `xe`:

```
i915.force_probe=46a6
xe.force_probe=!46a6
```

This is done by disabling the upstream nixos-hardware Precision 5570 module and inlining the kernel params in helios.nix.

**Bluetooth:** The Intel Bluetooth controller (8087:0033) crashes during firmware handoff at boot without `btusb.reset=0`.

**Boot quirks:** `spd5118` kernel module is blacklisted (causes wake-up instability). LUKS encrypted swap is configured here, not in the shared `boot.nix`.

**NVIDIA:** Hybrid mode with offload. Uses production drivers. Bus IDs hardcoded: Intel at `PCI:0:2:0`, NVIDIA at `PCI:1:0:0`. Run GPU-intensive apps with `nvidia-offload <command>`.

**Display:** Internal 1920x1200. Docked setup uses an LG UltraFine (3840x2160, rotated 90) and a Dell U2723QE (3840x2160). Monitor profiles managed by kanshi in `modules/home-manager/kanshi.nix`.

**Power:** TLP for power management, swayidle dims after 2 min, locks after 5 min, display off after 6 min, suspend after 10 min.

**SSH keys:** Two keys — `helios_personal_ed25519` (personal GitHub, default) and `helios_ed25519` (work, Cydar repos under `~/cydar/`). Conditional git includes switch identity by directory. Both keys preloaded into agent at login via a systemd user service.

## apollo — AMD 9950X desktop

Config: `modules/nixos/hosts/apollo.nix`

**GPU:** NVIDIA RTX 5080, discrete only (no hybrid). Uses latest drivers, not production.

**Gaming:** Full stack enabled via `modules/nixos/hosts/apollo-gaming.nix`:
- Steam with Proton, remote play firewall open, gamescope session
- Heroic Launcher (GOG library)
- Lutris (broader compatibility)
- MangoHud + GOverlay (performance overlay)
- ProtonUp-Qt (Proton version management)
- GameMode enabled

## halcyon — MacBook Pro 16

Config: `modules/darwin/system.nix`

**Package management:** Split between Nix and Homebrew. GUI apps that work better as native macOS apps go through Homebrew casks (1Password, Mullvad, Tor Browser, Little Snitch, etc.). Nix handles AeroSpace, Spotify, Discord, Logseq, CLI tools.

**Keyboard:** Caps Lock remapped to Escape. Key repeat is fast (KeyRepeat=2). All auto-correct features disabled.

**macOS defaults:** Dark mode, dock auto-hidden on the left with no persistent apps, Finder shows all files and POSIX paths, hot corners disabled, Touch ID for sudo.

**Homebrew cleanup:** Set to `zap` — removes anything not declared in `modules/darwin/system.nix`. If you install something with `brew` manually, it will be removed on next rebuild unless you add it to the config.
