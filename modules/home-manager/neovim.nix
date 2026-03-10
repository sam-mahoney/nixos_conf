{ pkgs, ... }:

{
  # === Neovim ===
  # Editor setup with LSP and Tree-sitter for core languages.
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      (nvim-treesitter.withPlugins (plugins: with plugins; [
        c
        cpp
        go
        javascript
        python
        tsx
        typescript
      ]))
    ];

    extraLuaConfig = ''
      local lspconfig = require("lspconfig")

      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      lspconfig.ts_ls.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.gopls.setup({ capabilities = capabilities })
      lspconfig.clangd.setup({ capabilities = capabilities })
      lspconfig.nil_ls.setup({ capabilities = capabilities })

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP: Find references" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover docs" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename symbol" })
    '';
  };
}
