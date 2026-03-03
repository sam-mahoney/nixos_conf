{ config, pkgs, ... }:

{
  # === Swaylock Configuration ===
  # Screen locker for Sway with blur effects (swaylock-effects)
  # Screen locker for Sway with blur effects and Catppuccin styling
  #
  # Catppuccin Mocha theme matching the rest of the desktop

  home.file.".config/swaylock/config".text = ''
    # === Effects ===
    screenshots
    clock
    indicator
    indicator-radius=100
    indicator-thickness=7
    effect-blur=7x5
    effect-vignette=0.5:0.5
    grace=2
    fade-in=0.2

    # === Colors (Catppuccin Mocha) ===
    # Inside (idle)
    inside-color=1e1e2e00
    inside-clear-color=1e1e2e00
    inside-caps-lock-color=1e1e2e00
    inside-ver-color=89b4fa44
    inside-wrong-color=f38ba844

    # Ring
    ring-color=45475a
    ring-clear-color=f9e2af
    ring-caps-lock-color=fab387
    ring-ver-color=89b4fa
    ring-wrong-color=f38ba8

    # Line (between ring and inside)
    line-color=00000000
    line-clear-color=00000000
    line-caps-lock-color=00000000
    line-ver-color=00000000
    line-wrong-color=00000000

    # Separator
    separator-color=00000000

    # Text
    text-color=cdd6f4
    text-clear-color=f9e2af
    text-caps-lock-color=fab387
    text-ver-color=89b4fa
    text-wrong-color=f38ba8

    # Key highlight
    key-hl-color=a6e3a1
    bs-hl-color=f38ba8

    # Layout
    font=JetBrainsMono Nerd Font
    font-size=24

    # Date/Time format
    timestr=%H:%M:%S
    datestr=%A, %d %B %Y
  '';
}
