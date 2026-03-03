# ⌨️ Keybinds Cheatsheet

All keybindings for the Helios NixOS setup. **Mod = Alt** (Aerospace-style).

---

## 🪟 Sway — Window Manager

### Core

| Key | Action |
|-----|--------|
| `Mod+Return` | Open terminal (Alacritty → tmux) |
| `Mod+d` | Application launcher (Noctalia) |
| `Mod+q` | Close focused window |
| `Mod+Shift+c` | Reload Sway config |
| `Mod+Shift+e` | Exit Sway (with confirmation) |
| `Mod+Escape` | Lock screen (swaylock) |

### Focus & Movement (vim-style)

| Key | Action |
|-----|--------|
| `Mod+h` | Focus left |
| `Mod+j` | Focus down |
| `Mod+k` | Focus up |
| `Mod+l` | Focus right |
| `Mod+Shift+h` | Move window left |
| `Mod+Shift+j` | Move window down |
| `Mod+Shift+k` | Move window up |
| `Mod+Shift+l` | Move window right |

### Workspaces

| Key | Action |
|-----|--------|
| `Mod+1` – `Mod+9` | Switch to workspace 1–9 |
| `Mod+Shift+1` – `Mod+Shift+9` | Move window to workspace 1–9 (and follow) |
| `Mod+Tab` | Workspace back-and-forth |
| `Mod+Shift+Tab` | Move window to previous workspace (and follow) |

### Layout

| Key | Action |
|-----|--------|
| `Mod+/` | Toggle horizontal / vertical tiling |
| `Mod+,` | Toggle tabbed / stacking (accordion) |
| `Mod+f` | Toggle fullscreen |
| `Mod+Shift+f` | Toggle floating |
| `Mod+Space` | Toggle focus between tiling/floating |
| `Mod+b` | Split horizontally |
| `Mod+v` | Split vertically |

### Resize

| Key | Action |
|-----|--------|
| `Mod+-` | Shrink width |
| `Mod+=` | Grow width |
| `Mod+Shift+-` | Shrink height |
| `Mod+Shift+=` | Grow height |
| `Mod+r` | Enter **resize mode** |

#### Resize Mode (press `Mod+r` first)

| Key | Action |
|-----|--------|
| `h` / `←` | Shrink width |
| `l` / `→` | Grow width |
| `k` / `↑` | Shrink height |
| `j` / `↓` | Grow height |
| `Escape` / `Return` | Exit resize mode |

### Scratchpad

| Key | Action |
|-----|--------|
| `Mod+s` | Show scratchpad |
| `Mod+Shift+s` | Move window to scratchpad |

### Multi-Monitor

| Key | Action |
|-----|--------|
| `Mod+.` | Focus next output (monitor) |
| `Mod+Shift+.` | Move workspace to next output |

### Screenshots

| Key | Action |
|-----|--------|
| `Print` | Screenshot full screen → clipboard |
| `Shift+Print` | Screenshot region → clipboard |
| `Mod+Print` | Screenshot full screen → save to ~/Pictures |

### Media & Hardware Keys

| Key | Action |
|-----|--------|
| `XF86AudioRaiseVolume` | Volume up 5% |
| `XF86AudioLowerVolume` | Volume down 5% |
| `XF86AudioMute` | Toggle mute output |
| `XF86AudioMicMute` | Toggle mute microphone |
| `XF86MonBrightnessUp` | Brightness up 5% |
| `XF86MonBrightnessDown` | Brightness down 5% |

---

## 🪟 Noctalia Shell — Desktop Shell

Noctalia keybinds are triggered via IPC calls from Sway.

| Key | Action |
|-----|--------|
| `Mod+Space` | Toggle app launcher |
| `Mod+n` | Toggle notification panel |
| `Mod+o` | Toggle control center / quick settings |
| `Mod+p` | Toggle power / session menu |

---

## 📟 tmux — Terminal Multiplexer

**Prefix: `Ctrl+a`** — press prefix first, then the key.

### Panes

| Key | Action |
|-----|--------|
| `Prefix + \|` | Split vertically (side by side) |
| `Prefix + -` | Split horizontally (top/bottom) |
| `Prefix + h` | Navigate pane left |
| `Prefix + j` | Navigate pane down |
| `Prefix + k` | Navigate pane up |
| `Prefix + l` | Navigate pane right |
| `Prefix + H` | Resize pane left |
| `Prefix + J` | Resize pane down |
| `Prefix + K` | Resize pane up |
| `Prefix + L` | Resize pane right |

### Windows

| Key | Action |
|-----|--------|
| `Prefix + c` | New window |
| `Prefix + n` | Next window |
| `Prefix + p` | Previous window |
| `Prefix + 1-9` | Switch to window number |
| `Prefix + ,` | Rename window |
| `Prefix + &` | Kill window |

### Sessions

| Key | Action |
|-----|--------|
| `Prefix + d` | Detach from session |
| `Prefix + s` | List sessions |
| `Prefix + $` | Rename session |

### Copy Mode (vi-style)

| Key | Action |
|-----|--------|
| `Prefix + [` | Enter copy mode |
| `v` | Begin selection (in copy mode) |
| `y` | Yank/copy selection → clipboard |
| `q` | Exit copy mode |

### Other

| Key | Action |
|-----|--------|
| `Prefix + r` | Reload tmux config |
| `Prefix + a` | Send prefix to nested tmux |

---

## 💡 Tips

- **Mod = Alt key** — inspired by Aerospace on macOS
- **Terminals always launch tmux** — your session persists across terminal restarts
- `tmux ls` — list all sessions from a regular shell
- `tmux attach -t main` — reattach to your main session
- Noctalia shell provides its own notification system, OSD, and control center — you can click the bar widgets or use the keybinds above
