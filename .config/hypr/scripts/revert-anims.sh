#!/usr/bin/env bash
# Restore the known-good Hyprland state: animations off, blur passes = 4.
#
# This is the state the desktop was in before the 2026-09-23 experiment that
# turned animations on (for the macOS-style 4-finger workspace swipe glide)
# and dropped blur to passes = 2 to pay for it. The 4-finger swipe itself is
# in the snapshot and survives the revert -- only the glide goes away.
set -euo pipefail

snapshot="$HOME/.config/hypr/hyprland.lua.snapshot.no-anims-blur4"
live="$HOME/.config/hypr/hyprland.lua"

[[ -f "$snapshot" ]] || { echo "missing snapshot: $snapshot" >&2; exit 1; }

cp "$live" "$live.bak.before-revert"
cp "$snapshot" "$live"
hyprctl reload

echo "reverted: animations off, blur passes = 4"
echo "previous config saved at $live.bak.before-revert"
