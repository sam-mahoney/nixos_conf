{ config, pkgs, ... }:

{
  # === Sway Wayland Compositor ===
  # i3-compatible tiling Wayland compositor
  # https://swaywm.org/
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;  # Fix GTK apps under Sway
    extraPackages = with pkgs; [
      swaylock-effects  # Screen locker with blur/effects
      swayidle          # Idle management daemon
      wl-clipboard      # Wayland clipboard utilities
      wlsunset          # Day/night gamma adjustments
      grim              # Screenshot tool
      slurp             # Region selector for screenshots
      wofi              # Application launcher (like rofi for Wayland)
      mako              # Notification daemon
    ];
  };

  # === XDG Portal for Sway ===
  # Enables screen sharing, file picker, etc. for Wayland apps
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # === Display Manager: greetd ===
  # Lightweight, minimal display manager for login
  # Using tuigreet for a text-based interface
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # tuigreet provides a terminal-based login screen
        # --time: Show current time
        # --remember: Remember last logged-in user
        # --remember-session: Remember last selected session
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
        user = "greeter";  # User account for the greeter process
      };
    };
  };

  # === GNOME Keyring ===
  # Secure storage for passwords, keys, and certificates
  # Integrates with PAM for automatic unlocking on login
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.swaylock = {};  # Allow swaylock to authenticate

  # === Console Keyboard Layout ===
  # British keyboard layout for TTY/console
  console.keyMap = "uk";
}
