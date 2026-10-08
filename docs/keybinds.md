# Keybinds

All keybindings across the stack. **Mod = Alt** everywhere (Sway, AeroSpace, tmux prefixless binds).

## Sway (Linux window manager)

Config: `modules/home-manager/sway.nix`

### Basics

| Key | Action |
|-----|--------|
| `Mod+Return` | Terminal (Ghostty) |
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
| `Alt+Enter` | Open Ghostty |
| `Alt+Shift+b` | Open Firefox |
| `Alt+Shift+;` | Service mode (reload config, flatten tree, close all but current) |

Auto-assigns: Firefox→4, Tor Browser→4 (floating), Slack→9.

## Ghostty (terminal)

Config: `modules/home-manager/ghostty.nix`. Every window opens straight into tmux: **tabs are tmux windows** (the bar at the bottom), and Ghostty provides splits. Ghostty's own tabs are switched off because AeroSpace tiles each native macOS tab as a separate window.

| macOS | Linux | Action |
|-------|-------|--------|
| `Cmd+T` | `Ctrl+Shift+T` | New tab (tmux window, same folder) |
| `Cmd+1-9` | `Prefix+1-9` | Go to tab N |
| `Cmd+Shift+]` / `Cmd+Shift+[` | `Ctrl+PgDn` / `Ctrl+PgUp` | Next / previous tab |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous tab |
| `Cmd+D` / `Cmd+Shift+D` | `Ctrl+Shift+O` / `Ctrl+Shift+E` | Split right / down |
| `Cmd+Alt+arrows` | `Ctrl+Alt+arrows` | Move between splits |
| `Cmd+Ctrl+arrows` | `Super+Ctrl+Shift+arrows` | Resize split |
| `Cmd+Shift+Enter` | `Ctrl+Shift+Enter` | Zoom split |
| `Cmd+W` | `Ctrl+Shift+W` | Close split / window |
| `Cmd+Shift+P` | `Ctrl+Shift+P` | Command palette (search every action) |

- The first window attaches the tmux session `main` (the same one `ta` uses). Closing it keeps your tabs, and the next window you open reattaches them. Extra windows get temporary sessions that are removed when the window closes.
- Close a single tab with `exit` or `Prefix+&`.
- Tab shortcuts send tmux keys, so use them in the tmux pane. Inside a Ghostty split they reach a plain shell and do nothing useful.
- On Linux, `Alt+1-9` belongs to Sway workspaces, so use `Prefix+1-9` for tabs.
- The config is managed by Nix: `Cmd+,` opens a read-only file. Edit `ghostty.nix` instead.

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
