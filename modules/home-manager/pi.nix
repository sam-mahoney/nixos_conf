{
  config,
  pkgs,
  inputs,
  ...
}:

# Extensions and skills from github:amosblomqvist/pi-config, linked into
# ~/.pi/agent. pi writes settings.json, auth.json, models-store.json and
# sessions/ itself, so those stay unmanaged.
let
  src = inputs.pi-config;

  # Each extension is linked as a whole directory: Node resolves node_modules
  # next to the real path of index.ts, so both must live in one store path.
  mkNpmExt =
    name:
    pkgs.buildNpmPackage {
      pname = "pi-ext-${name}";
      version = "0";
      src = "${src}/extensions/${name}";
      # Reads package-lock.json directly, so input bumps need no hash update.
      npmDeps = pkgs.importNpmLock { npmRoot = "${src}/extensions/${name}"; };
      npmConfigHook = pkgs.importNpmLock.npmConfigHook;
      dontNpmBuild = true;
      installPhase = "cp -r . $out";
    };

  # The lockfile pins playwright-core 1.60; use nixpkgs' playwright-core so it
  # matches the Chromium in playwright-driver.browsers.
  browserExt = pkgs.runCommand "pi-ext-browser" { } ''
    cp -r ${src}/extensions/browser $out
    chmod -R u+w $out
    mkdir -p $out/node_modules
    ln -s ${pkgs.playwright-driver} $out/node_modules/playwright-core
  '';

  # SKILL.md calls SKILL_DIR/.venv/bin/python; a Nix python env stands in.
  pdfReaderSkill = pkgs.runCommand "pi-skill-pdf-reader" { } ''
    cp -r ${src}/skills/pdf-reader $out
    chmod -R u+w $out
    ln -s ${pkgs.python313.withPackages (ps: [ ps.pymupdf ])} $out/.venv
  '';

  extensions = {
    "ask-user-question.ts" = "${src}/extensions/ask-user-question.ts";
    "custom-header.ts" = "${src}/extensions/custom-header.ts";
    "prompt-snippets" = "${src}/extensions/prompt-snippets";
    "web-search" = "${src}/extensions/web-search";
    "bash-guard" = mkNpmExt "bash-guard";
    "web-fetch" = mkNpmExt "web-fetch";
    "browser" = browserExt;
  };

  skills = {
    "analyze-sessions" = "${src}/skills/analyze-sessions";
    "web-debug" = "${src}/skills/web-debug";
    "youtube-transcript" = "${src}/skills/youtube-transcript";
    "pdf-reader" = pdfReaderSkill;
  };

  link =
    dir: entries:
    builtins.listToAttrs (
      map (name: {
        name = ".pi/agent/${dir}/${name}";
        value.source = entries.${name};
      }) (builtins.attrNames entries)
    );
in
{
  home.file = link "extensions" extensions // link "skills" skills;

  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
    # Default profile dir is inside the (read-only) extension directory.
    PI_BROWSER_PROFILE = "${config.home.homeDirectory}/.pi/agent/browser-profile";
  };

  # web-search reads GOOGLE_SEARCH_API_KEY / GOOGLE_CSE_ID; keep them out of git.
  programs.zsh.initContent = ''
    [[ -f ~/.config/pi/secrets.env ]] && source ~/.config/pi/secrets.env
  '';
}
