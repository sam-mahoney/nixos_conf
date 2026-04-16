{
  inputs,
  ...
}:

let
  cavemanSrc = inputs.caveman;
  defaultOpencodeConfig = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    model = "copilot/claude-sonnet-4-5";
    small_model = "copilot/gpt-4o-mini";
    disabled_providers = [ ];
    keybinds.leader = "ctrl+o";
    autoupdate = false;
    lsp = {
      typescript = {
        command = [ "typescript-language-server" "--stdio" ];
        extensions = [ "ts" "tsx" "js" "jsx" "mjs" "cjs" ];
      };
      python = {
        command = [ "pyright-langserver" "--stdio" ];
        extensions = [ "py" "pyi" ];
      };
      go = {
        command = [ "gopls" ];
        extensions = [ "go" ];
      };
      c = {
        command = [ "clangd" "--background-index" ];
        extensions = [ "c" "h" ];
      };
      cpp = {
        command = [ "clangd" "--background-index" ];
        extensions = [ "cc" "cpp" "cxx" "hpp" "hh" "hxx" ];
      };
      nix = {
        command = [ "nil" ];
        extensions = [ "nix" ];
      };
    };
  };

  cavemanDirective = ''
    Terse like caveman. Technical substance exact. Only fluff die.
    Drop: articles, filler (just/really/basically), pleasantries, hedging.
    Fragments OK. Short synonyms. Code unchanged.
    Pattern: [thing] [action] [reason]. [next step].
    ACTIVE EVERY RESPONSE. No revert after many turns. No filler drift.
    Code/commits/PRs: normal. Off: "stop caveman" / "normal mode".
  '';
in
{
  xdg.configFile."opencode/config.json".text = defaultOpencodeConfig;
  xdg.configFile."opencode/AGENTS.md".text = cavemanDirective;
  xdg.configFile."claude/CLAUDE.md".text = cavemanDirective;

  xdg.configFile."opencode/plugins/caveman" = {
    source = "${cavemanSrc}/plugins/caveman";
    recursive = true;
  };

  xdg.configFile."opencode/skills/caveman" = {
    source = "${cavemanSrc}/skills/caveman";
    recursive = true;
  };

  xdg.configFile."opencode/skills/caveman-commit" = {
    source = "${cavemanSrc}/skills/caveman-commit";
    recursive = true;
  };

  xdg.configFile."opencode/skills/caveman-review" = {
    source = "${cavemanSrc}/skills/caveman-review";
    recursive = true;
  };

  xdg.configFile."opencode/skills/caveman-compress" = {
    source = "${cavemanSrc}/caveman-compress";
    recursive = true;
  };
}
