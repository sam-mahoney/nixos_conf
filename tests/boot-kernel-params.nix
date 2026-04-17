let
  flake = builtins.getFlake (toString ../.);
  config = flake.nixosConfigurations.helios.config;
  params = config.boot.kernelParams;
  sharedParams = [
    "quiet"
    "loglevel=3"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
  ];
  hasXeEnable = builtins.elem "xe.force_probe=46a6" params;
  hasXeDisable = builtins.elem "xe.force_probe=!46a6" params;
  hasI915Enable = builtins.elem "i915.force_probe=46a6" params;
  hasI915Disable = builtins.elem "i915.force_probe=!46a6" params;
in
assert builtins.all (param: builtins.elem param params) sharedParams;
assert (!hasXeEnable);
assert hasXeDisable;
assert hasI915Enable;
assert (!hasI915Disable);
true
