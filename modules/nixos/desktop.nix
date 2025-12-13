{ config, pkgs, ... }:

{
  # === Hyprland Wayland Compositor ===
  # Modern, dynamic tiling Wayland compositor
  # https://hyprland.org/
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;  # X11 application compatibility
  };

  # === X11 Windowing System ===
  # Legacy display server (still needed for some applications)
  services.xserver.enable = true;

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
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions";
        user = "greeter";  # User account for the greeter process
      };
    };
  };

  # === GNOME Desktop Environment ===
  # Full-featured desktop environment (available as fallback)
  services.desktopManager.gnome.enable = true;
  
  # === GNOME Keyring ===
  # Secure storage for passwords, keys, and certificates
  # Integrates with PAM for automatic unlocking on login
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # === X11 Keyboard Layout ===
  # British keyboard layout for X11 applications
  services.xserver.xkb = {
    layout = "gb";  # UK keyboard layout
    variant = "";   # Standard variant (no modifications)
  };

  # === Console Keyboard Layout ===
  # British keyboard layout for TTY/console
  console.keyMap = "uk";
}
