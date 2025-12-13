{ config, pkgs, ... }:

{
  # === Audio Configuration ===
  
  # Disable PulseAudio (replaced by PipeWire)
  services.pulseaudio.enable = false;
  
  # === RealtimeKit ===
  # Allows PipeWire to acquire realtime scheduling priority
  # Reduces audio latency and prevents crackling/stuttering
  security.rtkit.enable = true;
  
  # === PipeWire ===
  # Modern multimedia framework for audio and video
  # Replaces both PulseAudio and JACK with lower latency
  # https://pipewire.org/
  services.pipewire = {
    enable = true;
    
    # ALSA support (Advanced Linux Sound Architecture)
    alsa.enable = true;
    alsa.support32Bit = true;  # Enable 32-bit ALSA for compatibility
    
    # PulseAudio compatibility layer
    # Allows PulseAudio applications to work with PipeWire
    pulse.enable = true;
    
    # JACK Audio Connection Kit (optional)
    # Uncomment for professional audio applications
    # jack.enable = true;
  };

  # === Printing Services ===
  # CUPS (Common Unix Printing System)
  # Enables printing to local and network printers
  services.printing.enable = true;

  # === Input Devices ===
  # libinput provides touchpad and touchscreen support
  # Includes gesture support, palm detection, etc.
  services.libinput.enable = true;
}
