# fastfetch logos cheat sheet

Everything about the fastfetch logo setup on **linuxbox** and **vm103**.
Same copy lives at `~/.config/fastfetch/README.md`.

---

## TL;DR

```sh
fflogo                  # list your logos
fflogo tux              # preview one (does NOT change the config)
fflogo all              # flip through them all
fflogo set tux          # apply it
fflogo builtins arch    # search fastfetch's 483 builtin logos
mklogo -m photo.jpg tulip 16    # turn any image into a braille logo
```

---

## Where things live

| Path | What |
|---|---|
| `~/.config/fastfetch/config.jsonc` | the live config — `fflogo set` rewrites its `logo` block |
| `~/.config/fastfetch/logos/` | the logo library, `<name>.ascii` + `<name>.colors` |
| `~/.local/bin/fflogo` | list / preview / apply logos |
| `~/.local/bin/mklogo` | image → braille logo (needs `chafa`) |
| `~/.config/fastfetch/config.jsonc.bak` | the original pre-Catnap config |

## The logo library

| name | lines | note |
|---|---|---|
| `rose-small` | 14 | the braille rose at half size |
| `rose` | 29 | full-detail braille rose, most realistic but tall |
| `rose-line` | 14 | plain line-art rose (the `smaller-rose.ascii` original) |
| `luffy` | 17 | full-colour half-block art from a picture, not placeholders |
| `keyboard` | 10 | mech board with a cable |
| `server` | 11 | rack — drive bays, blinkenlights |
| `terminal` | 11 | terminal window with a prompt |
| `camera` | 9 | body, lens, flash |
| `dragon` | 11 | classic ASCII dragon |
| `rocket` | 12 | |
| `mountain` | 10 | peaks over water |
| `moon` | 8 | crescent + stars |
| `pacman` | 11 | block art, with pellets |
| `cat` | 10 | curled sleeping cat |
| `skull` | 12 | |
| `coffee` | 11 | steaming cup |
| `tux` | 7 | |
| `dino` | 6 | |
| `ghost` | 8 | block-character pixel art |
| `heart` | 8 | block-character pixel art |
| `invader` | 8 | block-character pixel art |

Boxed art (`keyboard`, `server`, `terminal`, `camera`) and block art (`pacman`,
`heart`, `invader`) were generated from a grid in Python rather than typed by
hand — that is the reliable way to keep borders square and shapes symmetric.
Typing them by eye gets the right-hand border wrong every time.

Keep logos **around 14–17 lines**. The module list is 17 lines, so anything
taller leaves a big empty gap under the text — that is exactly why the
29-line `rose` felt oversized.

---

## Colours

Art files use `$1`–`$9` placeholders rather than hard-coded colours. Each
logo has a sidecar naming what those placeholders mean:

```
$ cat ~/.config/fastfetch/logos/tux.colors
yellow yellow green white
#  $1     $2     $3    $4
```

`fflogo set` copies that into the config's `logo.color` block. To recolour a
logo, edit the `.colors` file and re-run `fflogo set <name>` — never hand-edit
the config.

Valid names: `black red green yellow blue magenta cyan white` (and
`light_*` variants, e.g. `light_red`).

> **Watch out for `black`.** It is invisible on a dark terminal. Tux's feet
> were black at first and vanished; they are yellow now.

---

## Adding your own art

1. Drop `mything.ascii` into `~/.config/fastfetch/logos/`.
2. Prefix runs of characters with `$1`, `$2`… where you want colour changes.
   A placeholder stays in effect until the next one, including across lines.
3. Write `mything.colors` with the colour names, e.g. `red white green cyan`.
4. `fflogo mything` to preview, `fflogo set mything` to apply.

Good sources: <https://www.asciiart.eu>, and `fastfetch --list-logos` for the
484 builtins.

## Images → logos (`mklogo`)

This is how to get more of the photographic braille look:

```sh
mklogo -m rose.jpg   myrose 16    # mono braille, tint it via myrose.colors
mklogo    sunset.png sunset 14    # full colour, keeps the image's own colours
```

- Third argument is the **row count**; width is auto (2× rows, since braille
  cells are tall and narrow).
- Full-colour output contains real ANSI escapes, so `fflogo set` automatically
  switches the config to `"type": "file-raw"`. Mono output uses `"type": "file"`
  with the `$1`–`$4` placeholders.
- High-contrast images with a clear subject work best. Busy photos turn to mush
  at 14 rows.

### Braille vs half-blocks

`mklogo -m` (mono braille) only works for art with **clean dark outlines on a
plain background** — the rose. Feed it a colour illustration and everything
crosses the threshold, so you get a solid blob. That is exactly what happened
with `luffy`.

For anything coloured, skip `mklogo` and use half-blocks instead — two vertical
pixels per character cell, each with its own colour:

```sh
chafa --format symbols --symbols vhalf+space --animate=off --polite=on \
      --size 44x18 --margin-bottom 0 --margin-right 0 pic.png \
  | sed -e 's/\x1b\[?25[lh]//g' > ~/.config/fastfetch/logos/pic.ascii
```

No `.colors` sidecar — the escapes are baked in, and `fflogo set` notices that
and writes `"type": "file-raw"`. Crop transparent margins off the source first
or you get a logo made mostly of empty space.

### Real images (what the rice you linked does)

That Hyprland rice uses `"type": "kitty"` with a PNG — no ASCII at all. Your
terminal is `foot`, which does **sixel** rather than the kitty protocol:

```jsonc
"logo": { "source": "~/.config/fastfetch/images/luffy.png",
          "type": "sixel", "height": 18 }
```

Sharpest possible, but it only renders in `foot` — over SSH, in a TTY, or in the
VNC session you get nothing. The half-block version works everywhere, which is
why `luffy` in the library is the half-block one. Source images live in
`~/.config/fastfetch/images/`.

---

## How the small rose was made

`rose.ascii` is braille art: every character is a 2×4 grid of dots. So the art
was decoded into a 78×116 bitmap, box-downsampled 2×, and re-encoded as
braille — 29×39 became 14×20. That halves the resolution, which is why the
bloom is chunkier than the original. `rose.ascii` is still there untouched if
you ever want the detailed one back.

---

## Manual config reference

If you ever edit `config.jsonc` by hand, the logo block looks like:

```jsonc
"logo": {
    "source": "~/.config/fastfetch/logos/tux.ascii",
    "type": "file",          // "file-raw" for art with embedded ANSI colour
    "color": { "1": "yellow", "2": "yellow", "3": "green", "4": "white" },
    "padding": { "top": 1 }
}
```

`"type"` values that matter:

| value | meaning |
|---|---|
| `file` | read the file, process `$1`–`$9` placeholders |
| `file-raw` | print the file byte-for-byte, keep embedded ANSI colour |
| `builtin` | a name from `fastfetch --list-logos` |
| `sixel` / `kitty` | a real image; `foot` supports sixel |

---

## Gotchas

- **Colours vanish when piping.** `fastfetch | less` strips them. Use
  `fastfetch --pipe false` to force them on.
- **No `color` block = no colour.** A file logo with `$1` placeholders and no
  `logo.color` mapping renders plain. That was the original bug.
- **`cp` is aliased to prompt on overwrite**, which hangs scripts. Use
  `command cp -f`.
- **`find ~` stalls** on the sshfs mounts. Add `-xdev`.

---

## Syncing to another mesh box

```sh
tar cf - .config/fastfetch .local/bin/fflogo .local/bin/mklogo \
    fastfetch-logos-cheatsheet.md | ssh vm103 'tar xf - -C ~'
```

Needs `fastfetch` and `chafa` installed on the target.
