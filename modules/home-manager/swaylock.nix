{ config, pkgs, ... }:

{
  # === Swaylock Configuration ===
  # Screen locker for Sway with blur effects (swaylock-effects)
  # Screen locker for Sway with blur effects and a geohot-style palette
  #
  # Minimal black/grey lock screen matching the rest of the desktop

  home.file.".config/swaylock/config".text = ''
    # === Basic lock screen ===
    clock
    indicator
    grace=2
    fade-in=0.1
    color=000000
    screenshots
    effect-blur=8x4
    effect-vignette=0.2:0.2

    # === Colors (aligned with terminal + Noctalia palette) ===
    inside-color=000000dd
    inside-clear-color=000000dd
    inside-caps-lock-color=000000dd
    inside-ver-color=000000dd
    inside-wrong-color=000000dd

    ring-color=3a3a3a
    ring-clear-color=9a9a9a
    ring-caps-lock-color=9a9a9a
    ring-ver-color=c0c0c0
    ring-wrong-color=ff8080

    line-color=00000000
    line-clear-color=00000000
    line-caps-lock-color=00000000
    line-ver-color=00000000
    line-wrong-color=00000000

    separator-color=00000000

    text-color=d8d8d8
    text-clear-color=d8d8d8
    text-caps-lock-color=d8d8d8
    text-ver-color=d8d8d8
    text-wrong-color=ff8080

    key-hl-color=c0c0c0
    bs-hl-color=ff8080

    font=JetBrainsMono Nerd Font
    font-size=22

    timestr=%H:%M
    datestr=%a %d %b %Y
  '';
}
