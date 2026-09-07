#!/bin/bash
# Toggle `blur=` in ~/.config/foot/foot.ini between yes and no.
#
# NOTE: foot has no config-reload mechanism, and it never asks the compositor to
# *remove* a blur region once set. So the new value applies to foot windows
# opened from now on; windows already running keep the blur state they started
# with.

FOOT_CONFIG="$HOME/.config/foot/foot.ini"
[ -f "$FOOT_CONFIG" ] || { notify-send "Foot blur" "No $FOOT_CONFIG"; exit 1; }

# Current value: the blur= line inside a [colors*] section.
current=$(awk -F= '
    /^[[:space:]]*\[/ { in_colors = ($0 ~ /^\[colors/) ; next }
    in_colors && $1 ~ /^[[:space:]]*blur[[:space:]]*$/ { gsub(/[[:space:]]/,"",$2); print $2; exit }
' "$FOOT_CONFIG")

case "$current" in
    yes|true|1) new=no ;;
    *)          new=yes ;;
esac

if [ -n "$current" ]; then
    awk -v new="$new" '
        /^[[:space:]]*\[/ { in_colors = ($0 ~ /^\[colors/) }
        in_colors && !done && /^[[:space:]]*blur[[:space:]]*=/ { print "blur=" new; done=1; next }
        { print }
    ' "$FOOT_CONFIG" > "$FOOT_CONFIG.tmp" && mv "$FOOT_CONFIG.tmp" "$FOOT_CONFIG"
else
    # No blur key yet - add one to [colors-dark], or create the section.
    if grep -q '^\[colors-dark\]' "$FOOT_CONFIG"; then
        awk -v new="$new" '
            { print }
            /^\[colors-dark\]/ && !done { print "blur=" new; done=1 }
        ' "$FOOT_CONFIG" > "$FOOT_CONFIG.tmp" && mv "$FOOT_CONFIG.tmp" "$FOOT_CONFIG"
    else
        printf '\n[colors-dark]\nblur=%s\n' "$new" >> "$FOOT_CONFIG"
    fi
fi

notify-send -a foot "Foot blur: $new" "Applies to new foot windows (Super+Return)"
