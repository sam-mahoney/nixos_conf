{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Enables battery reporting for BT devices
      };
    };
  };

  services.blueman.enable = true;

  # PulseAudio replaced by PipeWire below.
  services.pulseaudio.enable = false;

  # rtkit lets PipeWire acquire realtime scheduling, reducing audio latency.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;
  services.libinput.enable = true;
}
