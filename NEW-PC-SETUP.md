# New PC Setup (From Scratch)

This guide gets a brand-new machine onto this NixOS flake configuration.

## 1) Install base NixOS

1. Boot the NixOS installer USB.
2. Partition and mount your disks at `/mnt` (UEFI + root, and swap if desired).
3. Generate initial config:

```bash
sudo nixos-generate-config --root /mnt
```

## 2) Clone this repo into the target system

From the installer environment:

```bash
sudo nix-shell -p git
sudo mkdir -p /mnt/etc
sudo git clone <your-repo-url> /mnt/etc/nixos
```

If your branch is not `master`, check out the correct branch inside `/mnt/etc/nixos`.

## Optional: Store config outside `/etc/nixos`

You can keep this repo anywhere (for example `~/nixos-conf`) and still use `nixos-rebuild` normally.

### Option A: Use explicit flake path (recommended)

```bash
# Example location
git clone <your-repo-url> ~/nixos-conf

# Rebuild from anywhere
sudo nixos-rebuild switch --flake ~/nixos-conf#apollo
```

### Option B: Keep old `/etc/nixos`-based command via symlink

```bash
# Example: real repo in home directory
git clone <your-repo-url> ~/nixos-conf

# Point /etc/nixos to that repo (backup first if needed)
[ -e /etc/nixos ] && sudo mv /etc/nixos /etc/nixos.backup.$(date +%s)
sudo ln -s ~/nixos-conf /etc/nixos

# Existing command continues to work
sudo nixos-rebuild switch --flake /etc/nixos#apollo
```

For day-to-day use, many people add an alias:

```bash
alias nrs-apollo='sudo nixos-rebuild switch --flake ~/nixos-conf#apollo'
```

## 3) Generate Apollo hardware config

Replace the Apollo hardware file with this machine's detected hardware config:

```bash
sudo nixos-generate-config --show-hardware-config > /mnt/etc/nixos/hardware-configuration-apollo.nix
```

## 4) Update machine-specific settings

Edit these files in `/mnt/etc/nixos`:

- `modules/nixos/hosts/apollo.nix` → host-level settings for desktop (`networking.hostName`, NVIDIA config)
- `modules/nixos/users.nix` → ensure the user account matches your desired username/details
- `home.nix` and any module values tied to machine/user-specific paths if needed

## 5) Install using the flake

```bash
sudo nixos-install --flake /mnt/etc/nixos#apollo
```

> `apollo` includes host-specific settings in `modules/nixos/hosts/apollo.nix` and hardware from `hardware-configuration-apollo.nix`.

Reboot after install completes.

## 6) First boot checks

On the new machine, run:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#apollo
nix flake check /etc/nixos
```

## 7) Gaming setup on Apollo (Steam + GOG)

Apollo includes:

- Steam (`programs.steam.enable = true`) for native + Proton gaming
- Heroic Launcher (`heroic`) for GOG library support
- Lutris for additional launcher/runtime compatibility
- MangoHud + GOverlay + GameMode for performance tuning

After first rebuild, open apps from your launcher and sign in:

- Steam → install and run your Steam titles (e.g. Cyberpunk 2077)
- Heroic → sign into GOG and install your GOG games

## 8) Enable local secret scanning hook (recommended)

Inside the repo on the new machine:

```bash
git config core.hooksPath .githooks
.githooks/pre-commit
```

This runs a local secret scan before commits.

---

## Host targets in this flake

This repo now includes two host targets:

- `#helios` for the laptop (Dell Precision 5570)
- `#apollo` for the desktop (AMD 9950X + RTX 5080)

Use the matching target when installing/rebuilding:

```bash
sudo nixos-install --flake /mnt/etc/nixos#apollo
sudo nixos-rebuild switch --flake /etc/nixos#apollo
```
