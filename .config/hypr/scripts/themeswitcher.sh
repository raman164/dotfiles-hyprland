#!/usr/bin/env bash
# Super+T - pick a full desktop theme (wofi menu), mirroring vm109's switcher.
# Only two entries: the box's original dark setup, and paperlike.
_U=$(id -u)
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$_U}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"

declare -A THEMES=(
    ["   Default  (TokyoNight)"]="revert"
    ["   Paperlike  (Light)"]="apply"
)
order=("   Default  (TokyoNight)" "   Paperlike  (Light)")

CHOICE=$(printf '%s\n' "${order[@]}" | wofi --dmenu --prompt "Theme:" --width 320 --height 140)
[ -z "$CHOICE" ] && exit 0

case "${THEMES[$CHOICE]}" in
    apply)  "$HOME/bin/paperlike"        >/dev/null 2>&1; MSG="Paperlike (light)" ;;
    revert) "$HOME/bin/paperlike-revert" >/dev/null 2>&1; MSG="Default (TokyoNight)" ;;
    *) exit 0 ;;
esac
command -v notify-send >/dev/null && notify-send "Theme" "$MSG — reopen terminals/Thunar to refresh"
