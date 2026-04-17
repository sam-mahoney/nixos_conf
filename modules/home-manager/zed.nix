{ pkgs, ... }:

let
  p = (import ../theme.nix).palette;
in
{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "toml"
    ];

    extraPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];

    mutableUserSettings = false;
    mutableUserKeymaps = false;

    userSettings = {
      vim_mode = true;

      theme = {
        mode = "dark";
        dark = "Monochrome";
      };

      ui_font_size = 16;
      buffer_font_size = 14;
      buffer_font_family = "monospace";

      tab_size = 2;
      hard_tabs = false;
      format_on_save = "off";
      scroll_beyond_last_line = "off";

      gutter = {
        line_numbers = true;
        git_blame = true;
      };

      terminal = {
        shell.program = "zsh";
        font_size = 14;
      };

      languages = {
        Nix = {
          language_servers = [ "nixd" "!nil" ];
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
        };
      };

      lsp = {
        nixd = {
          settings = {
            diagnostic.suppress = [ "sema-extra-with" ];
          };
        };
      };
    };

    themes = {
      "Monochrome" = {
        name = "Monochrome";
        author = "theme.nix";
        themes = [
          {
            name = "Monochrome";
            appearance = "dark";
            style = {
              background = p.bg;
              "editor.background" = p.bg;
              "editor.foreground" = p.fg;
              "editor.gutter.background" = p.bg;
              "editor.line_number" = p.gray4;
              "editor.active_line_number" = p.white;
              "editor.active_line.background" = p.bg_alt;
              "editor.highlight.background" = p.gray5;
              "editor.document_highlight.read_background" = p.gray5;
              "editor.document_highlight.write_background" = p.gray5;

              "panel.background" = p.bg;
              "panel.focused_border" = p.gray5;
              "pane.focused_border" = p.gray5;

              "tab_bar.background" = p.bg;
              "tab.active_background" = p.bg_alt;
              "tab.inactive_background" = p.bg;

              "toolbar.background" = p.bg;
              "status_bar.background" = p.bg;
              "title_bar.background" = p.bg;
              "title_bar.inactive_background" = p.bg;

              "scrollbar.track.background" = p.bg;
              "scrollbar.thumb.background" = p.gray5;

              "terminal.background" = p.bg;
              "terminal.foreground" = p.fg;
              "terminal.bright_foreground" = p.fg_bright;
              "terminal.ansi.black" = p.bg;
              "terminal.ansi.white" = p.fg;
              "terminal.ansi.bright_black" = p.gray4;
              "terminal.ansi.bright_white" = p.white;
              "terminal.ansi.red" = p.red;
              "terminal.ansi.bright_red" = p.red;

              border = p.gray5;
              "border.variant" = p.gray5;
              "border.focused" = p.gray3;
              "border.selected" = p.gray3;
              "border.disabled" = p.gray5;

              "element.background" = p.bg_alt;
              "element.hover" = p.gray5;
              "element.selected" = p.gray5;

              "ghost_element.background" = p.bg;
              "ghost_element.hover" = p.bg_alt;
              "ghost_element.selected" = p.gray5;

              "text" = p.fg;
              "text.muted" = p.gray4;
              "text.placeholder" = p.gray4;
              "text.accent" = p.gray1;

              "icon" = p.gray2;
              "icon.muted" = p.gray4;

              "elevated_surface.background" = p.bg_alt;
              "surface.background" = p.bg_alt;

              "search.match_background" = p.gray5;

              "players" = [
                {
                  cursor = p.white;
                  background = p.gray3;
                  selection = p.gray5;
                }
              ];

              "syntax" = {
                "comment" = { color = p.gray4; font_style = "italic"; };
                "string" = { color = p.fg_bright; };
                "keyword" = { color = p.gray1; font_weight = 700; };
                "function" = { color = p.gray1; font_weight = 700; };
                "type" = { color = p.gray1; };
                "variable" = { color = p.fg; };
                "constant" = { color = p.gray1; };
                "number" = { color = p.gray2; };
                "boolean" = { color = p.gray1; font_weight = 700; };
                "operator" = { color = p.gray2; };
                "property" = { color = p.fg; };
                "punctuation" = { color = p.gray2; };
                "attribute" = { color = p.gray2; };
                "label" = { color = p.gray2; };
                "tag" = { color = p.gray1; };
                "predictive" = { color = p.gray4; font_style = "italic"; };
              };

              "diagnostic_error" = p.red;
              "diagnostic_warning" = p.gray1;
              "diagnostic_info" = p.gray2;
              "diagnostic_hint" = p.gray3;

              "git.created" = p.fg_bright;
              "git.modified" = p.gray1;
              "git.deleted" = p.red;
              "git.conflict" = p.red;
              "git.ignored" = p.gray4;
              "git.renamed" = p.gray2;
            };
          }
        ];
      };
    };
  };
}
