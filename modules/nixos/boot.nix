{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  # Cap boot menu entries so /boot doesn't fill with old generations' kernels.
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  # Suppress verbose boot messages for a clean greeter.
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
  ];

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  # Live systemd job tree on the boot console, from the initrd (incl. the
  # LUKS prompt) through to greetd, and again on shutdown.
  services.bootvine.enable = true;
}
