# Keybinds & shortcuts

Every binding below is transcribed from the live configs in this repo. Source of
truth for each section is linked at its heading — if a bind here disagrees with
the config, the config wins.

- `SUPER` is the main modifier (`mainMod` in `hyprland.lua`).
- Hyprland binds live in [`.config/hypr/hyprland.lua`](.config/hypr/hyprland.lua).
  `shortcuts.conf` is **legacy** — it was folded into the Lua config during the
  0.56 migration and is no longer sourced.

---

## Hyprland — launching

| Bind | Action |
|---|---|
| `SUPER + Return` | foot terminal |
| `SUPER + D` | wofi (`--show drun`) |
| `SUPER + Space` | fuzzel |
| `SUPER + B` | firefox |
| `SUPER + E` | thunar |
| `SUPER + W` | wifi menu (`scripts/wifi-menu.sh`) |
| `SUPER + SHIFT + P` | pavucontrol |

## Hyprland — windows

| Bind | Action |
|---|---|
| `SUPER + Q` | close window |
| `SUPER + F` | fullscreen |
| `SUPER + V` | toggle floating |
| `SUPER + P` | pseudo-tile |
| `SUPER + U` | toggle split direction |
| `SUPER + h/j/k/l` | move focus (also arrow keys) |
| `SUPER + SHIFT + H/J/K/L` | move window within layout |
| `SUPER + LMB drag` | move window |
| `SUPER + RMB drag` | resize window |

## Hyprland — workspaces

| Bind | Action |
|---|---|
| `SUPER + 1…9`, `SUPER + 0` | switch to workspace 1–10 (`0` = 10) |
| `SUPER + SHIFT + 1…9`, `+ 0` | move window to workspace 1–10 |
| `SUPER + scroll down` | next workspace |
| `SUPER + scroll up` | previous workspace |

## Hyprland — theming & bar

| Bind | Action |
|---|---|
| `SUPER + S` | waybar theme switcher (24 themes) |
| `SUPER + T` | desktop theme switcher — default (TokyoNight) ⇄ paperlike (light) |
| `SUPER + SHIFT + W` | restart waybar |
| `SUPER + CTRL + W` | waypaper (wallpaper picker) |
| `SUPER + R` | foot theme switcher |
| `SUPER + SHIFT + B` | foot blur toggle |

## Hyprland — screenshots

| Bind | Action |
|---|---|
| `SUPER + ALT + S` | full screen → `~/Pictures/sc/` + clipboard |
| `SUPER + SHIFT + S` | region select (slurp) → `~/Pictures/sc/` + clipboard |

## Hyprland — session

| Bind | Action |
|---|---|
| `CTRL + ALT + Delete` | exit Hyprland |

## Hyprland — media & function keys

| Key | Action |
|---|---|
| `XF86MonBrightnessUp` / `Down` | `backlight up` / `down` (repeats) |
| `XF86AudioRaiseVolume` / `LowerVolume` | `volume up` / `down` (repeats) |
| `XF86AudioMute` | `volume mute` |
| `XF86AudioMicMute` | toggle mic mute |
| `XF86AudioPlay` / `Pause` | playerctl play-pause / pause |
| `XF86AudioNext` / `Prev` | playerctl next / previous |
| `XF86Calculator` | qalculate-gtk |
| `XF86Tools` | dotfiles settings script (floating alacritty) |

---

## tmux — [`.config/tmux/tmux.conf`](.config/tmux/tmux.conf)

Prefix is remapped from `C-b` to **`C-a`**.

| Bind | Action |
|---|---|
| `C-a C-a` | send a literal `C-a` |
| `C-a \|` | split horizontally |
| `C-a -` | split vertically |
| `C-a r` | reload tmux.conf |
| `Alt + ←/→/↑/↓` | select pane (no prefix needed) |
| `C-a g` | popup shell (80%×80%) |
| `C-a G` | popup git status + last 10 commits |
| `C-a m` | popup htop |
| `C-a f` | popup file manager (lf → ranger → ls) |
| `C-a P` | toggle pane logging to `~/Documents/learning/tmux-logs/` |
| `C-a H` | save scrollback history to a file |

Note: the default `"` and `%` split binds are unbound.

---

## Neovim — [`.config/nvim/lua/rb/`](.config/nvim/lua/rb/)

Leader is **`Space`**.

### Editing

| Bind | Action |
|---|---|
| `jk` (insert) | exit insert mode |
| `C-a` / `C-e` | start / end of line (normal, visual, insert) |
| `Alt + j/k` | move line or selection down/up |
| `Alt + d` | duplicate line down |
| `<leader>+` / `<leader>-` | increment / decrement number (normal, visual) |
| `<leader>nh` | clear search highlights |
| `<leader>q` | quit |
| `s` / `ss` / `S` | substitute with motion / line / to end of line |
| `s` (visual) | substitute selection |

### Splits & tabs

| Bind | Action |
|---|---|
| `<leader>sv` / `<leader>sh` | split vertical / horizontal |
| `<leader>se` | equalize splits |
| `<leader>sx` | close split |
| `<leader>sj/sk/sl/sH` | move split bottom/top/right/left |
| `<leader>sw` | swap split with next |
| `<leader>sr` | rotate splits |
| `<leader>to` / `<leader>tx` | new / close tab |
| `<leader>tn` / `<leader>tp` | next / previous tab |
| `<leader>tf` | current buffer in new tab |

### Files & search (telescope, nvim-tree)

| Bind | Action |
|---|---|
| `<leader>ff` | find files in cwd |
| `<leader>fs` | live grep in cwd |
| `<leader>fc` | grep string under cursor |
| `<leader>fb` | fuzzy find in current buffer |
| `<leader>ft` | find TODOs |
| `<leader>ee` | toggle file explorer |
| `<leader>ef` | explorer on current file |
| `<leader>ec` / `<leader>er` | collapse / refresh explorer |

### Sessions, tools, running code

| Bind | Action |
|---|---|
| `<leader>ws` / `<leader>wr` | save / restore session for cwd |
| `<leader>l` | `:Lazy` |
| `<leader>m` | `:Mason` |
| `<leader>p` | run current file with python3 |
| `<leader>pm` | run python3 in a vertical terminal split |
| `<leader>c` | compile & run current C++ file |
| `<leader>ai` | AI generate (`:Gen`) |
| `<leader>tr` / `<leader>ts` | Typr / Typr stats |

---

## foot — [`.config/foot/foot.ini`](.config/foot/foot.ini)

| Bind | Action |
|---|---|
| `Control + v` | paste from clipboard |
| `F11` | fullscreen |

Remaining binds are foot's defaults (`Control+Shift+c/v`, `Control+Shift+n`, etc.).

## yazi — [`.config/yazi/keymap.toml`](.config/yazi/keymap.toml)

Uses yazi's stock vim-style keymap (223 bindings) — `j`/`k` to move, `gg`/`G` for
top/bottom, `C-u`/`C-d` half page, `q` quit, `Q` quit without cwd-file. See the
file for the full list.
