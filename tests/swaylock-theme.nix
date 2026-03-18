let
  file = builtins.readFile ../modules/home-manager/swaylock.nix;
  hasCyanAccent = builtins.match ".*ring-ver-color=6ee7ff.*" file != null;
  hasDeepBlur = builtins.match ".*effect-blur=12x6.*" file != null;
  hasVignette = builtins.match ".*effect-vignette=0\.35:0\.35.*" file != null;
  hasLargeClock = builtins.match ".*font-size=24.*" file != null;
in
assert hasCyanAccent;
assert hasDeepBlur;
assert hasVignette;
assert hasLargeClock;
true
