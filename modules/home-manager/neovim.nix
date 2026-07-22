{ pkgs, theme, ... }:

let
  p = theme.palette;
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      plenary-nvim
      telescope-nvim
      gitsigns-nvim
      comment-nvim
      nvim-surround
      nvim-autopairs
      conform-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          bash c cpp go javascript json lua markdown markdown_inline
          nix python query regex toml tsx typescript vim vimdoc yaml
        ]
      ))
    ];

    initLua = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = ","

      -- Palette sourced from modules/theme.nix
      local palette = {
        bg = "${p.bg}",
        bg_alt = "${p.bg_alt}",
        fg = "${p.fg}",
        fg_bright = "${p.fg_bright}",
        white = "${p.white}",
        gray_1 = "${p.gray1}",
        gray_2 = "${p.gray2}",
        gray_3 = "${p.gray3}",
        gray_4 = "${p.gray4}",
        gray_5 = "${p.gray5}",
        red = "${p.red}",
      }

      local set_hl = vim.api.nvim_set_hl
      vim.cmd("highlight clear")
      vim.cmd("syntax reset")
      vim.o.background = "dark"
      vim.g.colors_name = "terminal_mono"

      -- UI chrome
      set_hl(0, "Normal", { fg = palette.fg, bg = palette.bg })
      set_hl(0, "NormalNC", { fg = palette.fg, bg = palette.bg })
      set_hl(0, "NormalFloat", { fg = palette.fg, bg = palette.bg_alt })
      set_hl(0, "FloatBorder", { fg = palette.gray_5, bg = palette.bg_alt })
      set_hl(0, "FloatTitle", { fg = palette.gray_1, bg = palette.bg_alt, bold = true })
      set_hl(0, "CursorLine", { bg = palette.bg_alt })
      set_hl(0, "CursorColumn", { bg = palette.bg_alt })
      set_hl(0, "ColorColumn", { bg = palette.bg_alt })
      set_hl(0, "CursorLineNr", { fg = palette.white, bg = palette.bg_alt, bold = true })
      set_hl(0, "LineNr", { fg = palette.gray_4, bg = palette.bg })
      set_hl(0, "SignColumn", { fg = palette.gray_4, bg = palette.bg })
      set_hl(0, "VertSplit", { fg = palette.gray_5, bg = palette.bg })
      set_hl(0, "WinSeparator", { fg = palette.gray_5, bg = palette.bg })
      set_hl(0, "StatusLine", { fg = palette.fg_bright, bg = palette.bg_alt })
      set_hl(0, "StatusLineNC", { fg = palette.gray_4, bg = palette.bg_alt })
      set_hl(0, "TabLine", { fg = palette.gray_4, bg = palette.bg_alt })
      set_hl(0, "TabLineFill", { fg = palette.gray_4, bg = palette.bg })
      set_hl(0, "TabLineSel", { fg = palette.white, bg = palette.bg, bold = true })
      set_hl(0, "Pmenu", { fg = palette.fg, bg = palette.bg_alt })
      set_hl(0, "PmenuSel", { fg = palette.bg, bg = palette.gray_3, bold = true })
      set_hl(0, "PmenuSbar", { bg = palette.gray_5 })
      set_hl(0, "PmenuThumb", { bg = palette.gray_2 })
      set_hl(0, "Visual", { fg = palette.bg, bg = palette.gray_3 })
      set_hl(0, "Search", { fg = palette.bg, bg = palette.gray_3 })
      set_hl(0, "IncSearch", { fg = palette.bg, bg = palette.gray_1, bold = true })
      set_hl(0, "CurSearch", { fg = palette.bg, bg = palette.gray_1, bold = true })
      set_hl(0, "MatchParen", { fg = palette.white, bg = palette.gray_5, bold = true })
      set_hl(0, "Directory", { fg = palette.gray_1, bold = true })
      set_hl(0, "Title", { fg = palette.gray_1, bold = true })
      set_hl(0, "Question", { fg = palette.gray_1, bold = true })
      set_hl(0, "NonText", { fg = palette.gray_5 })
      set_hl(0, "Whitespace", { fg = palette.gray_5 })
      set_hl(0, "EndOfBuffer", { fg = palette.bg })

      -- Syntax
      set_hl(0, "Comment", { fg = palette.gray_4, italic = true })
      set_hl(0, "Constant", { fg = palette.gray_1 })
      set_hl(0, "String", { fg = palette.fg_bright })
      set_hl(0, "Character", { fg = palette.fg_bright })
      set_hl(0, "Number", { fg = palette.gray_2 })
      set_hl(0, "Boolean", { fg = palette.gray_1, bold = true })
      set_hl(0, "Float", { fg = palette.gray_2 })
      set_hl(0, "Identifier", { fg = palette.fg })
      set_hl(0, "Function", { fg = palette.gray_1, bold = true })
      set_hl(0, "Statement", { fg = palette.gray_1, bold = true })
      set_hl(0, "Conditional", { fg = palette.gray_1, bold = true })
      set_hl(0, "Repeat", { fg = palette.gray_1, bold = true })
      set_hl(0, "Label", { fg = palette.gray_2 })
      set_hl(0, "Operator", { fg = palette.gray_2 })
      set_hl(0, "Keyword", { fg = palette.gray_1, bold = true })
      set_hl(0, "Exception", { fg = palette.red, bold = true })
      set_hl(0, "PreProc", { fg = palette.gray_2 })
      set_hl(0, "Include", { fg = palette.gray_2, bold = true })
      set_hl(0, "Define", { fg = palette.gray_2 })
      set_hl(0, "Macro", { fg = palette.gray_2 })
      set_hl(0, "PreCondit", { fg = palette.gray_2 })
      set_hl(0, "Type", { fg = palette.gray_1 })
      set_hl(0, "StorageClass", { fg = palette.gray_2 })
      set_hl(0, "Structure", { fg = palette.gray_1 })
      set_hl(0, "Typedef", { fg = palette.gray_1 })
      set_hl(0, "Special", { fg = palette.gray_2 })
      set_hl(0, "SpecialComment", { fg = palette.gray_3, italic = true })
      set_hl(0, "Underlined", { fg = palette.gray_1, underline = true })
      set_hl(0, "Todo", { fg = palette.bg, bg = palette.gray_1, bold = true })
      set_hl(0, "Error", { fg = palette.red, bold = true })
      set_hl(0, "ErrorMsg", { fg = palette.red, bold = true })
      set_hl(0, "WarningMsg", { fg = palette.gray_1, bold = true })

      -- Diagnostics
      set_hl(0, "DiagnosticError", { fg = palette.red })
      set_hl(0, "DiagnosticWarn", { fg = palette.gray_1 })
      set_hl(0, "DiagnosticInfo", { fg = palette.gray_2 })
      set_hl(0, "DiagnosticHint", { fg = palette.gray_3 })
      set_hl(0, "DiagnosticOk", { fg = palette.fg_bright })
      set_hl(0, "DiagnosticVirtualTextError", { fg = palette.red, bg = palette.bg_alt })
      set_hl(0, "DiagnosticVirtualTextWarn", { fg = palette.gray_1, bg = palette.bg_alt })
      set_hl(0, "DiagnosticVirtualTextInfo", { fg = palette.gray_2, bg = palette.bg_alt })
      set_hl(0, "DiagnosticVirtualTextHint", { fg = palette.gray_3, bg = palette.bg_alt })
      set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = palette.red })
      set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = palette.gray_1 })
      set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = palette.gray_2 })
      set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = palette.gray_3 })
      set_hl(0, "DiagnosticFloatingError", { fg = palette.red, bg = palette.bg_alt })
      set_hl(0, "DiagnosticFloatingWarn", { fg = palette.gray_1, bg = palette.bg_alt })
      set_hl(0, "DiagnosticFloatingInfo", { fg = palette.gray_2, bg = palette.bg_alt })
      set_hl(0, "DiagnosticFloatingHint", { fg = palette.gray_3, bg = palette.bg_alt })
      set_hl(0, "DiagnosticSignError", { fg = palette.red, bg = palette.bg })
      set_hl(0, "DiagnosticSignWarn", { fg = palette.gray_1, bg = palette.bg })
      set_hl(0, "DiagnosticSignInfo", { fg = palette.gray_2, bg = palette.bg })
      set_hl(0, "DiagnosticSignHint", { fg = palette.gray_3, bg = palette.bg })

      -- Plugin highlights
      set_hl(0, "GitSignsAdd", { fg = palette.fg_bright, bg = palette.bg })
      set_hl(0, "GitSignsChange", { fg = palette.gray_1, bg = palette.bg })
      set_hl(0, "GitSignsDelete", { fg = palette.red, bg = palette.bg })

      set_hl(0, "TelescopeNormal", { fg = palette.fg, bg = palette.bg_alt })
      set_hl(0, "TelescopeBorder", { fg = palette.gray_5, bg = palette.bg_alt })
      set_hl(0, "TelescopeTitle", { fg = palette.gray_1, bg = palette.bg_alt, bold = true })
      set_hl(0, "TelescopePromptNormal", { fg = palette.fg_bright, bg = palette.bg_alt })
      set_hl(0, "TelescopePromptBorder", { fg = palette.gray_5, bg = palette.bg_alt })
      set_hl(0, "TelescopePromptPrefix", { fg = palette.gray_2, bg = palette.bg_alt })
      set_hl(0, "TelescopeSelection", { fg = palette.bg, bg = palette.gray_3, bold = true })
      set_hl(0, "TelescopeSelectionCaret", { fg = palette.bg, bg = palette.gray_3, bold = true })
      set_hl(0, "TelescopeMatching", { fg = palette.white, bold = true })

      set_hl(0, "CmpItemAbbr", { fg = palette.fg })
      set_hl(0, "CmpItemAbbrMatch", { fg = palette.white, bold = true })
      set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = palette.gray_1, bold = true })
      set_hl(0, "CmpItemMenu", { fg = palette.gray_4 })
      set_hl(0, "CmpItemKind", { fg = palette.gray_2 })

      -- Editor options
      local opt = vim.opt
      opt.number = true
      opt.relativenumber = true
      opt.mouse = "a"
      opt.clipboard = "unnamedplus"
      opt.breakindent = true
      opt.undofile = true
      opt.ignorecase = true
      opt.smartcase = true
      opt.signcolumn = "yes"
      opt.updatetime = 250
      opt.timeoutlen = 300
      opt.splitright = true
      opt.splitbelow = true
      opt.inccommand = "split"
      opt.cursorline = true
      opt.scrolloff = 6
      opt.sidescrolloff = 6
      opt.expandtab = true
      opt.shiftwidth = 2
      opt.tabstop = 2
      opt.smartindent = true
      opt.termguicolors = true
      opt.completeopt = { "menu", "menuone", "noselect" }

      vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

      -- Telescope
      local telescope = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Help tags" })

      -- Plugin setup
      require("gitsigns").setup()
      require("Comment").setup()
      require("nvim-surround").setup()
      require("nvim-autopairs").setup()

      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })

      -- Completion
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
      })

      -- LSP
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = {
        clangd = {},
        gopls = {},
        nil_ls = {},
        pyright = {},
        ts_ls = {},
      }

      for server, config in pairs(servers) do
        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
          end

          map("gd", vim.lsp.buf.definition, "LSP: Go to definition")
          map("gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
          map("gr", telescope.lsp_references, "LSP: References")
          map("gi", telescope.lsp_implementations, "LSP: Implementations")
          map("<leader>ds", telescope.lsp_document_symbols, "LSP: Document symbols")
          map("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "LSP: Workspace symbols")
          map("<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "LSP: Code action", { "n", "x" })
          map("K", vim.lsp.buf.hover, "LSP: Hover")
          map("<leader>fd", function() vim.diagnostic.open_float(nil, { border = "rounded" }) end, "Diagnostics: Line")
          map("[d", vim.diagnostic.goto_prev, "Diagnostics: Previous")
          map("]d", vim.diagnostic.goto_next, "Diagnostics: Next")
        end,
      })

      -- Formatting
      require("conform").setup({
        notify_on_error = true,
        format_on_save = false,
        formatters_by_ft = {
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          json = { "prettier" },
          lua = { "stylua" },
          markdown = { "prettier" },
          nix = { "nixfmt" },
          sh = { "shfmt" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          yaml = { "prettier" },
        },
      })

      vim.keymap.set("n", "<leader>fm", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })

      -- Writing mode for prose
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "gitcommit", "markdown", "text" },
        callback = function(event)
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.spell = true
          vim.opt_local.textwidth = 80
          vim.opt_local.colorcolumn = ""
        end,
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = true,
        signs = true,
        virtual_text = { spacing = 2, source = "if_many" },
      })
    '';
  };
}
