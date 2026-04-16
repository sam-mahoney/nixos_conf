# Keybinds

All keybindings across the stack. **Mod = Alt** everywhere (Sway, AeroSpace, tmux prefixless binds).

## Sway (Linux window manager)

Config: `modules/home-manager/sway.nix`

### Basics

| Key | Action |
|-----|--------|
| `Mod+Return` | Terminal (Alacritty) |
| `Mod+d` | App launcher (Noctalia) |
| `Mod+q` | Close window |
| `Mod+Shift+c` | Reload Sway |
| `Mod+Shift+e` | Exit Sway |
| `Mod+Escape` | Lock screen |

### Focus and movement (vim-style)

| Key | Action |
|-----|--------|
| `Mod+hjkl` | Focus left/down/up/right |
| `Mod+Shift+hjkl` | Move window left/down/up/right |

### Workspaces

| Key | Action |
|-----|--------|
| `Mod+1-9` | Switch to workspace |
| `Mod+Shift+1-9` | Move window to workspace (and follow) |
| `Mod+Tab` | Back-and-forth |
| `Mod+Shift+Tab` | Move window to previous workspace |

### Layout

| Key | Action |
|-----|--------|
| `Mod+/` | Toggle horizontal/vertical tiling |
| `Mod+,` | Toggle tabbed/stacking |
| `Mod+f` | Fullscreen |
| `Mod+Shift+f` | Toggle floating |
| `Mod+Space` | Toggle focus tiling/floating |
| `Mod+b` / `Mod+v` | Split horizontal / vertical |

### Resize

| Key | Action |
|-----|--------|
| `Mod+-` / `Mod+=` | Shrink/grow width |
| `Mod+Shift+-` / `Mod+Shift+=` | Shrink/grow height |
| `Mod+r` | Enter resize mode (hjkl to resize, Esc to exit) |

### Other

| Key | Action |
|-----|--------|
| `Mod+s` / `Mod+Shift+s` | Show / hide scratchpad |
| `Mod+.` / `Mod+Shift+.` | Focus / move to next monitor |
| `Print` | Screenshot (full) to clipboard |
| `Shift+Print` | Screenshot (region) to clipboard |
| `Mod+Print` | Screenshot to ~/Pictures |

### Noctalia shell panels

| Key | Action |
|-----|--------|
| `Mod+d` | App launcher |
| `Mod+n` | Notification history |
| `Mod+o` | Control center / quick settings |
| `Mod+p` | Power / session menu |

### Media keys

Volume up/down/mute and brightness up/down work on the hardware keys as expected.

## AeroSpace (macOS window manager)

Config: `modules/home-manager/aerospace.nix`

Same Alt+hjkl muscle memory as Sway, with these differences:

| Key | Action |
|-----|--------|
| `Alt+Shift+Enter` | Open Alacritty |
| `Alt+Shift+b` | Open Firefox |
| `Alt+m` | Fullscreen (not Alt+f) |
| `Alt+Shift+;` | Service mode (reload config, flatten tree, close all but current) |

Auto-assigns: Alacritty→1, Logseq→3, Firefox→4, Tor Browser→4 (floating), Slack→9.

## tmux

Config: `modules/home-manager/tmux.nix`. Prefix: **Ctrl+a**.

### Panes

| Key | Action |
|-----|--------|
| `Prefix+\|` or `Prefix+\` | Split vertical |
| `Prefix+-` | Split horizontal |
| `Prefix+hjkl` | Navigate panes |
| `Prefix+HJKL` | Resize panes |
| `Alt+hjkl` | Navigate panes (no prefix) |
| `Alt+Shift+hjkl` | Resize panes (no prefix) |

**Note:** The prefixless `Alt+hjkl` bindings overlap with Sway's focus bindings on Linux. Inside tmux on Sway, tmux captures them. Outside tmux, Sway handles them. This is usually fine but can be surprising.

### Windows and sessions

| Key | Action |
|-----|--------|
| `Prefix+c` | New window |
| `Prefix+n` / `Prefix+p` | Next / previous window |
| `Prefix+1-9` | Switch to window |
| `Prefix+d` | Detach |
| `Prefix+s` | List sessions |
| `Prefix+r` | Reload config |

### Copy mode

`Prefix+[` to enter, `v` to select, `y` to yank to clipboard, `q` to exit.

## Neovim

Config: `modules/home-manager/neovim.nix`. Leader: **Space**.

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `gd` / `gD` | Go to definition / declaration |
| `gr` / `gi` | References / implementations |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>ds` / `<leader>ws` | Document / workspace symbols |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>fd` | Line diagnostics float |
| `<leader>fm` | Format buffer |
| `<C-Space>` | Trigger completion |
