{ config, lib, pkgs, theme, ... }:

let
  p = theme.palette;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  # Ghostty's palette is 16 indexed entries: normal 0-7, bright 8-15
  ansiOrder = [ "black" "red" "green" "yellow" "blue" "magenta" "cyan" "white" ];
  ansiColours =
    map (c: theme.ansi.normal.${c}) ansiOrder ++ map (c: theme.ansi.bright.${c}) ansiOrder;

  # Every window opens into tmux, which provides the tabs. The first window takes the
  # persistent "main" session (the one `ta` attaches to), so closing it keeps your tabs;
  # extra windows get throwaway sessions that are destroyed when the window closes.
  tmux = lib.getExe config.programs.tmux.package;
  tmuxLauncher = pkgs.writeShellScript "ghostty-tmux" ''
    if [ -z "$(${tmux} list-clients -t main 2>/dev/null)" ]; then
      exec ${tmux} new-session -A -s main
    fi
    exec ${tmux} new-session \; set-option destroy-unattached on
  '';

  # Ghostty's own tabs stay unused: AeroSpace tiles each native macOS tab as a
  # separate window. The usual tab shortcuts send tmux keys instead (prefix Ctrl+a = \x01).
  tmuxKey = k: "text:\\x01${k}";
  tabKeybinds =
    [
      "ctrl+tab=${tmuxKey "n"}"
      "ctrl+shift+tab=${tmuxKey "p"}"
    ]
    ++ lib.optionals isDarwin (
      [
        "super+t=${tmuxKey "c"}"
        "super+shift+]=${tmuxKey "n"}"
        "super+shift+[=${tmuxKey "p"}"
      ]
      # Ghostty binds both the character and the physical key, so override both
      ++ lib.concatMap (
        n:
        let
          k = toString n;
        in
        [
          "super+${k}=${tmuxKey k}"
          "super+digit_${k}=${tmuxKey k}"
        ]
      ) (lib.range 1 9)
    )
    ++ lib.optionals isLinux [
      "ctrl+shift+t=${tmuxKey "c"}"
      "ctrl+page_down=${tmuxKey "n"}"
      "ctrl+page_up=${tmuxKey "p"}"
    ];
in
{
  programs.ghostty = {
    enable = true;
    # On macOS nix-darwin installs Ghostty.app (nixGuiApps in modules/darwin/system.nix) so it
    # lands in /Applications/Nix Apps; Home Manager app linking is off there, so only write config.
    package = if isDarwin then null else pkgs.ghostty;
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
      # Frameless. On macOS this also disables native tabs, which is what we want (see tabKeybinds).
      window-decoration = "none";
      split-divider-color = p.gray5;

      # The first surface of each window runs tmux; Ghostty splits get a plain shell
      initial-command = "${tmuxLauncher}";
      # Linux defaults to one shared process, which would skip initial-command for new windows
      gtk-single-instance = false;
      keybind = tabKeybinds;

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
