{ lib, pkgs, theme, ... }:

let
  p = theme.palette;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  # Ghostty's palette is 16 indexed entries: normal 0-7, bright 8-15
  ansiOrder = [ "black" "red" "green" "yellow" "blue" "magenta" "cyan" "white" ];
  ansiColours =
    map (c: theme.ansi.normal.${c}) ansiOrder ++ map (c: theme.ansi.bright.${c}) ansiOrder;
in
{
  programs.ghostty = {
    enable = true;
    # nixpkgs only builds Ghostty from source on Linux; macOS gets the upstream .app
    package = if isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    # Sway launches a fresh process per window, so skip the background daemon
    systemd.enable = false;

    themes.oxocarbon = {
      background = p.bg;
      # Brighter foreground keeps text legible over a see-through background
      foreground = p.fg_bright;
      cursor-color = p.blue;
      cursor-text = p.bg;
      selection-background = p.gray5;
      selection-foreground = "cell-foreground";
      palette = lib.imap0 (i: c: "${toString i}=${c}") ansiColours;
    };

    settings = {
      theme = "oxocarbon";

      font-family = theme.fonts.mono;
      font-size = 12;

      # Only the default background goes translucent; apps that paint their
      # own bg (nvim, tmux) must use NONE/default to stay see-through.
      background-opacity = 0.6;
      # Blur radius, honoured on macOS (Alacritty's was fixed at 80). Stock Sway can't blur.
      background-blur = 40;

      window-padding-x = 4;
      window-padding-y = 4;
      window-decoration = "none";

      copy-on-select = "clipboard";

      # ssh-env: remote hosts rarely ship xterm-ghostty terminfo, so ssh gets xterm-256color.
      # sudo: keeps Ghostty's terminfo visible to `sudo nvim` and friends.
      shell-integration-features = "sudo,ssh-env";

      # AeroSpace opens a new instance per window (open -na), so let each exit with its window
      quit-after-last-window-closed = true;
      # Nix owns the version; stop Sparkle trying to update a read-only store path
      auto-update = "off";
    };
  };

  # Default terminal for anything that asks: Noctalia reads $TERMINAL,
  # GIO and Terminal=true desktop entries go through xdg-terminal-exec.
  home.sessionVariables = lib.mkIf isLinux { TERMINAL = "ghostty"; };
  xdg.terminal-exec = lib.mkIf isLinux {
    enable = true;
    settings.default = [ "com.mitchellh.ghostty.desktop" ];
  };
}
