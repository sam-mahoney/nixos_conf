# CLAUDE.md

@README.md

## Rules

- Colours come from `modules/theme.nix`. Don't hardcode hex values in a module (swaylock is the one exception).
- Host-specific hardware goes in `hosts/<host>/`, not in shared modules.
- Wayland desktop packages (wl-clipboard, grim, slurp, swaylock, swayidle) are installed system-level in `modules/nixos/desktop.nix`, not through Home Manager.
- Keep Alt keybindings consistent between `sway.nix` and `aerospace.nix`.
- Git identity and SSH keys are split work/personal by directory in `modules/home-manager/git.nix`.
- Validate with `nix flake check`. Don't run `switch` unless asked.
