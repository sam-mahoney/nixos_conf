# Neovim

Declaratively configured in `modules/home-manager/neovim.nix`. Formatter/linter CLIs installed in `modules/home-manager/packages.nix`.

## What's set up

- Neovim 0.11 native LSP (no mason, no lazy.nvim — everything comes from Nix)
- Completion: nvim-cmp + LuaSnip
- Fuzzy finding: Telescope
- Syntax: Tree-sitter
- Formatting: conform.nvim (manual with `<leader>fm`, format-on-save is off)
- Git gutter: gitsigns
- Quality-of-life: Comment.nvim, nvim-surround, nvim-autopairs

## Language servers

| Server | Languages |
|--------|-----------|
| `ts_ls` | TypeScript, JavaScript |
| `pyright` | Python |
| `gopls` | Go |
| `clangd` | C, C++ |
| `nil_ls` | Nix |
| `marksman` | Markdown |

## Formatters

| Formatter | Languages |
|-----------|-----------|
| `prettier` | Markdown, JSON, YAML, JS, TS |
| `nixfmt` | Nix |
| `stylua` | Lua |
| `shfmt` | Shell |

Also installed: `shellcheck` (diagnostics), `vale` (prose linting), `typos` (typo checking).

## Writing mode

For markdown, text, and gitcommit buffers: wrapping, spell check, and textwidth=80 are enabled automatically.

## Theme

Custom monochrome colorscheme (`terminal_mono`) — black background, grey/white foreground, no colour syntax highlighting. Matches the rest of the desktop.

## Keymaps

See [keybinds.md](keybinds.md#neovim) for the full list. Leader is Space.

## After changing the config

```bash
# Rebuild (picks up neovim.nix and packages.nix changes)
sudo nixos-rebuild switch --flake .#helios   # or darwin-rebuild switch --flake .#halcyon

# Verify nothing broke
nvim --headless +q
nvim --headless '+checkhealth vim.lsp' +qa
```
