{ ... }:

let
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
in
{
  xdg.configFile."opencode/config.json".text = defaultOpencodeConfig;
}
