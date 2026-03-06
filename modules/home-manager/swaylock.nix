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

    # === Colors (minimal black/grey) ===
    inside-color=000000dd
    inside-clear-color=000000dd
    inside-caps-lock-color=000000dd
    inside-ver-color=000000dd
    inside-wrong-color=000000dd

    ring-color=5f5f5f
    ring-clear-color=8a8a8a
    ring-caps-lock-color=8a8a8a
    ring-ver-color=a0a0a0
    ring-wrong-color=d75f5f

    line-color=00000000
    line-clear-color=00000000
    line-caps-lock-color=00000000
    line-ver-color=00000000
    line-wrong-color=00000000

    separator-color=00000000

    text-color=e6e6e6
    text-clear-color=e6e6e6
    text-caps-lock-color=e6e6e6
    text-ver-color=e6e6e6
    text-wrong-color=ff8080

    key-hl-color=a0a0a0
    bs-hl-color=d75f5f

    font=JetBrainsMono Nerd Font
    font-size=22

    timestr=%H:%M
    datestr=%a %d %b %Y
  '';
}
