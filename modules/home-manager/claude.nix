{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  # Merged into ~/.claude/settings.json on activation rather than symlinked,
  # because Claude Code writes to that file itself (permissions, /config, /plugin).
  # Only plugins are declared: preferences like effort and model are changed
  # in-session and would be reset on every rebuild.
  settings = {
    enabledPlugins = {
      "clangd-lsp@claude-plugins-official" = true;
      "pyright-lsp@claude-plugins-official" = true;
      "typescript-lsp@claude-plugins-official" = true;
      "gopls-lsp@claude-plugins-official" = true;
      "cc-plugin-you-should-know@builtin" = true;
      "explanatory-output-style@claude-plugins-official" = true;
    };
  };

  settingsFile = pkgs.writeText "claude-settings.json" (builtins.toJSON settings);
in
{
  home.file.".claude/skills/socratic-tutor".source = "${inputs.agent-skills}/socratic-tutor";

  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/.claude/settings.json"
    merged="$(mktemp)"
    if [ -f "$target" ]; then
      ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$target" ${settingsFile} > "$merged"
    else
      ${pkgs.jq}/bin/jq . ${settingsFile} > "$merged"
    fi
    run mkdir -p "$HOME/.claude"
    run install -m 644 "$merged" "$target"
    rm -f "$merged"
  '';
}
