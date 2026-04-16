# New machine setup

## NixOS (helios or apollo)

### 1. Install base NixOS

Boot the NixOS installer USB, partition disks, mount at `/mnt`.

```bash
sudo nixos-generate-config --root /mnt
```

### 2. Clone this repo

```bash
sudo nix-shell -p git
sudo git clone <repo-url> /mnt/etc/nixos
```

### 3. Generate hardware config

```bash
# For apollo:
sudo nixos-generate-config --show-hardware-config > /mnt/etc/nixos/hardware-configuration-apollo.nix

# For helios:
sudo nixos-generate-config --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix
```

### 4. Check host-specific settings

- `modules/nixos/hosts/<hostname>.nix` — hostname, GPU config
- `modules/nixos/users.nix` — username and groups

### 5. Install

```bash
sudo nixos-install --flake /mnt/etc/nixos#apollo   # or #helios
```

Reboot.

### 6. First boot

```bash
sudo nixos-rebuild switch --flake /etc/nixos#apollo
nix flake check /etc/nixos
```

### Optional: keep the repo outside /etc/nixos

```bash
git clone <repo-url> ~/nixos-conf
sudo nixos-rebuild switch --flake ~/nixos-conf#apollo
```

Or symlink: `sudo ln -s ~/nixos-conf /etc/nixos`

## macOS (halcyon)

```bash
# Install Nix (Determinate Systems or official installer)
git clone <repo-url> ~/nixos-conf
cd ~/nixos-conf
darwin-rebuild switch --flake .#halcyon
```

If migrating from an older darwin config, build first without switching to check for issues:

```bash
darwin-rebuild build --flake .#halcyon
ls -la ./result/sw/Applications
darwin-rebuild switch --flake .#halcyon
```

## After setup (all machines)

```bash
# Enable local secret scanning
git config core.hooksPath .githooks

# Apollo gaming: Steam, Heroic (GOG), Lutris, MangoHud are all included.
# Just sign in after first rebuild.
```
