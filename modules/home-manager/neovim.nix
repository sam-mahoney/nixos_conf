{ pkgs, ... }:

{
  # === Neovim ===
  # Editor setup with modern LSP, completion, fuzzy finding, and writing support.
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

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
          bash
          c
          cpp
          go
          javascript
          json
          lua
          markdown
          markdown_inline
          nix
          python
          query
          regex
          toml
          tsx
          typescript
          vim
          vimdoc
          yaml
        ]
      ))
    ];

    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = ","

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

      local telescope = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Help tags" })

      require("gitsigns").setup()
      require("Comment").setup()
      require("nvim-surround").setup()
      require("nvim-autopairs").setup()

      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })

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
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = {
        clangd = {},
        gopls = {},
        marksman = {},
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
        virtual_text = {
          spacing = 2,
          source = "if_many",
        },
      })
    '';
  };
}
