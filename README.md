<div align="center"><pre>
          ::::.    ':::::     ::::'        
          ':::::    ':::::.  ::::'         
            :::::     '::::.:::::          
      .......:::::..... ::::::::           
     ::::::::::::::::::. ::::::    ::::.   
    ::::::::::::::::::::: :::::.  .::::'   
           .....           ::::' :::::'    
          :::::            '::' :::::'     
 ........:::::               ' :::::::::::.
:::::::::::::                 :::::::::::::
 ::::::::::: ..              :::::         
     .::::: .:::            :::::          
    .:::::  :::::          '''''    .....  
    :::::   ':::::.  ......:::::::::::::'  
     :::     ::::::. ':::::::::::::::::'   
            .:::::::: '::::::::::          
           .::::''::::.     '::::.         
          .::::'   ::::.     '::::.        
         .::::      ::::      '::::.       
</pre></div>

# Nix Configuration

One flake, three machines.

| Host | Machine | System | Rebuild |
|------|---------|--------|---------|
| `helios` | Dell Precision 5570 laptop | NixOS | `sudo nixos-rebuild switch --flake .#helios` |
| `apollo` | AMD 9950X + RTX 5080 desktop | NixOS | `sudo nixos-rebuild switch --flake .#apollo` |
| `halcyon` | MacBook Pro 16 | nix-darwin | `darwin-rebuild switch --flake .#halcyon` |

Sway on Linux, AeroSpace on macOS. Ghostty + tmux, Neovim, Oxocarbon theme.

## Commands

```bash
sudo nixos-rebuild test --flake .#helios   # try without switching (macOS: darwin-rebuild build)
sudo nixos-rebuild switch --rollback       # undo
nix flake check                            # run tests/ and the gitleaks secret scan
nix flake update && git diff flake.lock    # update inputs, review before rebuilding
git config core.hooksPath .githooks        # once per clone: gitleaks pre-commit hook
```

## Layout

| Path | Contents |
|------|----------|
| `flake.nix` | Inputs, overlays, `mkLinuxHost` / `mkDarwinHost` |
| `configuration*.nix`, `home*.nix` | Per-host entrypoints. They only import modules |
| `modules/theme.nix` | The palette and gaps. Every UI module reads its colours from here |
| `modules/nixos/` | Linux system config. Hardware quirks are in `hosts/<host>.nix` |
| `modules/darwin/` | macOS system config, defaults and Homebrew |
| `modules/home-manager/` | User config, one file per tool. `common.nix` is the cross-platform baseline |
| `tests/` | Assertions on helios kernel params |

## Adding packages

| Kind | Where |
|------|-------|
| User, any platform | `modules/home-manager/packages.nix` -> `sharedPackages` (or `linuxOnlyPackages` / `darwinOnlyPackages`) |
| Linux system-wide | `modules/nixos/packages.nix` |
| macOS GUI app from Nix | `modules/darwin/system.nix` -> `nixGuiApps` |
| macOS Homebrew cask | `modules/darwin/system.nix` -> `homebrew.casks` |
| Newer than stable | add to `unstableOverlay` in `flake.nix` |

## Things to know

- Flakes only see files tracked by git. `git add` a new file before rebuilding.
- Homebrew cleanup is `zap`: anything installed with `brew` by hand is removed on the next rebuild.
- macOS GUI apps must go in `nixGuiApps`, not `home.packages`, or they never reach `/Applications`.
- helios forces the `i915` GPU driver over `xe` (external displays break otherwise) and sets `btusb.reset=0`. `tests/` guards both.
- On helios, run GPU-heavy programs with `nvidia-offload <command>`.
- Alt is the modifier in Sway, AeroSpace and tmux's prefixless binds. tmux prefix is `Ctrl+a`, Neovim leader is `Space`.
- Ghostty opens straight into tmux, so terminal tabs are tmux windows.
- swaylock has its own palette on purpose. Everything else uses `modules/theme.nix`.

## New machine

NixOS: install as usual, clone this repo, replace the host's `hardware-configuration*.nix` with the output of `nixos-generate-config --show-hardware-config`, then `sudo nixos-install --flake .#<host>`.

macOS: install Nix, clone, `darwin-rebuild switch --flake .#halcyon`.
