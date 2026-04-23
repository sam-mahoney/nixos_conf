{ config, pkgs, ... }:

{
  # === Swaylock Configuration ===
  # Screen locker for Sway with blur effects (swaylock-effects)
  # Screen locker for Sway with blur effects and a noir terminal palette
  # that matches the monochrome desktop while pushing it toward a colder,
  # more cinematic control-panel feel.

  home.file.".config/swaylock/config".text = ''
    # === Basic lock screen ===
    clock
    indicator
    grace=2
    fade-in=0.25
    color=020406
    screenshots
    effect-blur=12x6
    effect-vignette=0.35:0.35
    effect-greyscale

    # === Noir terminal palette ===
    inside-color=05080ce6
    inside-clear-color=071018ee
    inside-caps-lock-color=0f1419ee
    inside-ver-color=071018ee
    inside-wrong-color=18080cee

    ring-color=2b3138
    ring-clear-color=8aa4b8
    ring-caps-lock-color=b48ead
    ring-ver-color=6ee7ff
    ring-wrong-color=ff6b6b

    line-color=00000000
    line-clear-color=00000000
    line-caps-lock-color=00000000
    line-ver-color=00000000
    line-wrong-color=00000000

    separator-color=10161c00

    text-color=d9e2ec
    text-clear-color=d9e2ec
    text-caps-lock-color=f2c078
    text-ver-color=6ee7ff
    text-wrong-color=ff9b9b

    key-hl-color=6ee7ff
    bs-hl-color=ff6b6b

    font=JetBrainsMono Nerd Font
    font-size=24

    timestr=%H:%M
    datestr=%Y-%m-%d
  '';
}
