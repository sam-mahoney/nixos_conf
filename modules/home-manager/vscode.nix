{ pkgs, theme, ... }:

# VSCode setup tuned for reading first, light editing second. Autosave is on
# but format-on-save and aggressive suggestions stay off so the editor still
# behaves like a code browser. Add language servers per-project via direnv
# rather than enabling them globally here.
let
  p = theme.palette;
  monoFont = theme.fonts.mono;
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        eamodio.gitlens
        gruntfuggly.todo-tree
        alefragnani.bookmarks
        usernamehw.errorlens
        aaron-bond.better-comments
        pkief.material-icon-theme
        jnoortheen.nix-ide
        vscodevim.vim
        ms-python.python
        ms-pyright.pyright
      ];

      userSettings = {
        # Sticky scroll pins the current function/class header at the top of
        # the viewport — single most useful reading feature in modern VSCode.
        "editor.stickyScroll.enabled" = true;
        "editor.stickyScroll.maxLineCount" = 8;

        "editor.minimap.enabled" = false;

        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.guides.indentation" = true;
        "editor.renderWhitespace" = "boundary";
        "editor.wordWrap" = "off";
        "editor.smoothScrolling" = true;
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.showFoldingControls" = "always";
        "editor.foldingStrategy" = "indentation";
        "editor.linkedEditing" = true;
        "editor.semanticHighlighting.enabled" = true;
        "editor.inlayHints.enabled" = "offUnlessPressed";

        "breadcrumbs.enabled" = true;
        "breadcrumbs.filePath" = "on";
        "breadcrumbs.symbolPath" = "on";
        "breadcrumbs.symbolSortOrder" = "position";

        # Preview tabs: single-click opens an italicised throwaway tab; only
        # double-click or edit promotes it. Perfect for skimming many files.
        "workbench.editor.enablePreview" = true;
        "workbench.editor.enablePreviewFromQuickOpen" = true;
        "workbench.list.smoothScrolling" = true;
        "workbench.tree.indent" = 16;
        "workbench.tree.renderIndentGuides" = "always";

        # Autosave on a short delay — never lose work, but keep the rest of
        # the write-oriented noise off so the editor still feels calm.
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "editor.formatOnSave" = false;
        "editor.formatOnPaste" = false;
        "editor.formatOnType" = false;
        "editor.quickSuggestions" = {
          other = "off";
          comments = "off";
          strings = "off";
        };
        "editor.suggestOnTriggerCharacters" = false;
        "editor.parameterHints.enabled" = false;
        "editor.acceptSuggestionOnEnter" = "off";
        "editor.tabCompletion" = "off";

        "editor.fontFamily" = "'${monoFont}', monospace";
        "editor.fontSize" = 13;
        "editor.lineHeight" = 1.5;
        "editor.fontLigatures" = false;
        "terminal.integrated.fontFamily" = "'${monoFont}'";

        "workbench.iconTheme" = "material-icon-theme";
        "workbench.colorTheme" = "Default Dark Modern";

        # Monochrome palette from modules/theme.nix layered onto the base
        # dark theme so colour edits flow through the whole desktop.
        "workbench.colorCustomizations" = {
          "editor.background" = p.bg;
          "editor.foreground" = p.fg;
          "editorLineNumber.foreground" = p.gray5;
          "editorLineNumber.activeForeground" = p.gray2;
          "editorCursor.foreground" = p.gray1;
          "editor.selectionBackground" = p.gray5;
          "editor.lineHighlightBackground" = p.bg_alt;
          "editor.wordHighlightBackground" = p.bg_alt;
          "editorWhitespace.foreground" = p.gray5;
          "editorIndentGuide.background1" = p.bg_alt;
          "editorIndentGuide.activeBackground1" = p.gray5;
          "editorBracketMatch.background" = p.bg_alt;
          "editorBracketMatch.border" = p.gray3;

          "sideBar.background" = p.bg;
          "sideBar.foreground" = p.fg;
          "sideBarSectionHeader.background" = p.bg;
          "activityBar.background" = p.bg;
          "activityBar.foreground" = p.fg;
          "activityBar.inactiveForeground" = p.gray4;
          "titleBar.activeBackground" = p.bg;
          "titleBar.activeForeground" = p.fg;
          "titleBar.inactiveBackground" = p.bg;
          "statusBar.background" = p.bg;
          "statusBar.foreground" = p.fg;
          "statusBar.noFolderBackground" = p.bg;
          "panel.background" = p.bg;
          "panel.border" = p.gray5;
          "editorGroup.border" = p.gray5;
          "tab.activeBackground" = p.bg_alt;
          "tab.inactiveBackground" = p.bg;
          "tab.activeForeground" = p.fg_bright;
          "tab.inactiveForeground" = p.gray3;
          "tab.border" = p.bg;
          "terminal.background" = p.bg;
          "terminal.foreground" = p.fg;
          "errorForeground" = p.red;
          "editorError.foreground" = p.red;
        };

        "telemetry.telemetryLevel" = "off";
        "redhat.telemetry.enabled" = false;
        "update.mode" = "none";
        "extensions.autoUpdate" = false;
        "extensions.autoCheckUpdates" = false;

        # GitLens: inline blame is the single most useful reading aid; code
        # lens is noisy so it stays off.
        "gitlens.currentLine.enabled" = true;
        "gitlens.codeLens.enabled" = false;
        "gitlens.hovers.enabled" = true;
        "gitlens.statusBar.enabled" = true;
        "gitlens.blame.format" = "\${author|10} • \${agoOrDate|14-+}";

        "todo-tree.tree.scanMode" = "workspace";
        "todo-tree.general.tags" = [ "TODO" "FIXME" "XXX" "HACK" "NOTE" "BUG" ];

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        "files.trimTrailingWhitespace" = false;
        "files.insertFinalNewline" = false;
        "explorer.compactFolders" = false;

        # Vim mode — mirrors neovim.nix preferences (space leader, relative
        # numbers, system clipboard). Ctrl-c/v/f/a are left to VSCode so the
        # editor still feels native outside of motion-heavy work.
        "editor.lineNumbers" = "relative";
        "vim.leader" = "<space>";
        "vim.useSystemClipboard" = true;
        "vim.useCtrlKeys" = true;
        "vim.hlsearch" = true;
        "vim.incsearch" = true;
        "vim.smartRelativeLine" = true;
        "vim.handleKeys" = {
          "<C-c>" = false;
          "<C-v>" = false;
          "<C-x>" = false;
          "<C-f>" = false;
          "<C-a>" = false;
          "<C-z>" = false;
          "<C-y>" = false;
        };
        "vim.insertModeKeyBindings" = [
          { before = [ "j" "k" ]; after = [ "<Esc>" ]; }
        ];
        "vim.normalModeKeyBindingsNonRecursive" = [
          { before = [ "<Esc>" ]; commands = [ ":nohl" ]; }
          { before = [ "<leader>" "f" "f" ]; commands = [ "workbench.action.quickOpen" ]; }
          { before = [ "<leader>" "f" "g" ]; commands = [ "workbench.action.findInFiles" ]; }
          { before = [ "<leader>" "f" "b" ]; commands = [ "workbench.action.showAllEditors" ]; }
          { before = [ "<leader>" "d" "s" ]; commands = [ "workbench.action.gotoSymbol" ]; }
          { before = [ "<leader>" "w" "s" ]; commands = [ "workbench.action.showAllSymbols" ]; }
          { before = [ "<leader>" "c" "a" ]; commands = [ "editor.action.quickFix" ]; }
          { before = [ "<leader>" "r" "n" ]; commands = [ "editor.action.rename" ]; }
          { before = [ "g" "d" ]; commands = [ "editor.action.revealDefinition" ]; }
          { before = [ "g" "D" ]; commands = [ "editor.action.revealDeclaration" ]; }
          { before = [ "g" "r" ]; commands = [ "editor.action.goToReferences" ]; }
          { before = [ "g" "i" ]; commands = [ "editor.action.goToImplementation" ]; }
          { before = [ "K" ]; commands = [ "editor.action.showHover" ]; }
          { before = [ "[" "d" ]; commands = [ "editor.action.marker.prev" ]; }
          { before = [ "]" "d" ]; commands = [ "editor.action.marker.next" ]; }
        ];
      };
    };
  };
}
