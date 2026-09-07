#!/bin/sh
# Launches hyprpaper and applies wallpaper assignments via IPC.
# Workaround: hyprpaper >=0.8.4 ignores `wallpaper = monitor,/path` lines from
# its config file at startup, but the IPC command still works.
# Re-check after future hyprpaper upgrades — drop this script if upstream fixes it.

CONF="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprpaper.conf"

pkill -x hyprpaper 2>/dev/null
hyprpaper -c "$CONF" >/dev/null 2>&1 &

# Wait for hyprpaper IPC socket
for _ in 1 2 3 4 5 6 7 8 9 10; do
    if hyprctl hyprpaper listactive >/dev/null 2>&1; then
        break
    fi
    sleep 0.3
done

# Re-apply each `wallpaper = monitor,/path` line from the config via IPC
grep -E '^[[:space:]]*wallpaper[[:space:]]*=' "$CONF" | while IFS= read -r line; do
    arg=$(printf '%s' "$line" | sed -E 's/^[[:space:]]*wallpaper[[:space:]]*=[[:space:]]*//')
    hyprctl hyprpaper wallpaper "$arg" >/dev/null 2>&1
done

# Restore the wallpaper last picked in waypaper (after hyprpaper IPC is up above)
command -v waypaper >/dev/null 2>&1 && waypaper --restore >/dev/null 2>&1
