# Neovim Setup

Neovim is configured declaratively through Home Manager in `modules/home-manager/neovim.nix`.
Supporting editor, formatter, and writing tools are installed in `modules/home-manager/packages.nix`.

## What This Setup Includes

- Native Neovim 0.11 LSP configuration
- Completion with `nvim-cmp` and `LuaSnip`
- Tree-sitter highlighting and indentation
- Telescope fuzzy finding
- Git signs in the gutter
- Formatting through `conform.nvim`
- Markdown and prose support for writing

## Enabled Language Servers

The current setup enables these LSP servers:

- `clangd`
- `gopls`
- `marksman`
- `nil_ls`
- `pyright`
- `ts_ls`

## Installed Neovim Plugins

Configured in `modules/home-manager/neovim.nix`:

- `nvim-lspconfig`
- `nvim-treesitter`
- `plenary.nvim`
- `telescope.nvim`
- `gitsigns.nvim`
- `Comment.nvim`
- `nvim-surround`
- `nvim-autopairs`
- `conform.nvim`
- `nvim-cmp`
- `cmp-nvim-lsp`
- `cmp-buffer`
- `cmp-path`
- `cmp-cmdline`
- `LuaSnip`
- `cmp_luasnip`

## Installed CLI Tooling

Installed through `modules/home-manager/packages.nix`:

- `nodePackages.prettier` - formatter for Markdown, JSON, YAML, JavaScript, and TypeScript
- `stylua` - Lua formatter
- `shfmt` - shell formatter
- `shellcheck` - shell diagnostics
- `marksman` - Markdown language server
- `vale` - prose linting for docs and notes
- `typos` - typo checking for prose and code
- `nixfmt-rfc-style` - Nix formatter

## Formatting

Formatting is configured through `conform.nvim` and is available manually with `<leader>fm`.
Formatting on save is currently disabled by default.

Configured formatters:

- Lua -> `stylua`
- Shell -> `shfmt`
- Nix -> `nixfmt`
- Markdown -> `prettier`
- JSON -> `prettier`
- YAML -> `prettier`
- JavaScript / TypeScript -> `prettier`

## Writing Support

For `markdown`, `text`, and `gitcommit` buffers, Neovim enables:

- line wrapping
- line break friendly wrapping
- spell checking
- `textwidth=80`

This makes the setup usable for notes, docs, commit messages, and longer prose.

## Keymaps

Leader is set to `Space`.

### Telescope

- `<leader>ff` - find files
- `<leader>fg` - live grep
- `<leader>fb` - list buffers
- `<leader>fh` - help tags

### LSP

- `gd` - go to definition
- `gD` - go to declaration
- `gr` - references
- `gi` - implementations
- `K` - hover documentation
- `<leader>rn` - rename symbol
- `<leader>ca` - code action
- `<leader>ds` - document symbols
- `<leader>ws` - workspace symbols

### Diagnostics

- `[d` - previous diagnostic
- `]d` - next diagnostic
- `<leader>fd` - show diagnostics for current line

### Formatting

- `<leader>fm` - format current buffer

### Completion

- `<C-Space>` - trigger completion
- `<CR>` - confirm selected completion item
- `<Tab>` - next completion item or snippet jump
- `<S-Tab>` - previous completion item or snippet jump back

## Activation

After changing `modules/home-manager/neovim.nix` or related editor packages, rebuild and switch so the generated `~/.config/nvim/init.lua` matches the repo.

On Darwin:

```bash
sudo darwin-rebuild switch --flake .#halcyon
```

On NixOS:

```bash
sudo nixos-rebuild switch --flake .#helios
```

## Verification

Useful checks after changing the config:

```bash
nix flake check
```

```bash
nvim --headless +q
```

```bash
nvim --headless '+checkhealth vim.lsp' +qa
```

```bash
nvim --headless '+checkhealth telescope' +qa
```
