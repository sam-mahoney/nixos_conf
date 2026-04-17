let
  flake = builtins.getFlake (toString ../.);
  config = flake.nixosConfigurations.helios.config;
  params = config.boot.kernelParams;
in
assert (builtins.elem "btusb.reset=0" params);
assert (!builtins.elem "btusb.enable_autosuspend=0" params);
true
