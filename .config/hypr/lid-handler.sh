#!/bin/bash
# Hyprland lid event handler - smart clamshell mode

LOG_FILE="/tmp/lid-handler.log"
echo "$(date): Lid event triggered" >> "$LOG_FILE"

# Check if lid is closed
if grep -q closed /proc/acpi/button/lid/*/state; then
    echo "$(date): Lid is CLOSED" >> "$LOG_FILE"

    # Count external monitors (exclude eDP-1)
    EXTERNAL_MONITORS=$(hyprctl monitors -j | jq '[.[] | select(.name != "eDP-1")] | length')
    echo "$(date): External monitors detected: $EXTERNAL_MONITORS" >> "$LOG_FILE"

    if [ "$EXTERNAL_MONITORS" -gt 0 ]; then
        # External monitors connected - disable laptop screen only
        hyprctl keyword monitor "eDP-1,disable"
        echo "$(date): Clamshell mode - laptop screen disabled" >> "$LOG_FILE"
    else
        # No external monitors - lock and suspend
        echo "$(date): No external monitors - suspending" >> "$LOG_FILE"

        # Lock screen before suspend
        loginctl lock-session

        # Suspend - let TLP handle power management
        systemctl suspend

        echo "$(date): Suspend command issued" >> "$LOG_FILE"
    fi
else
    # Lid is open - enable laptop screen and restore CPU performance
    echo "$(date): Lid is OPEN - enabling laptop screen and restoring CPU" >> "$LOG_FILE"

    # Force display to wake up
    hyprctl dispatch dpms on >> "$LOG_FILE" 2>&1

    # Re-enable laptop screen
    hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1" >> "$LOG_FILE" 2>&1

    # Restore saved brightness level
    brightnessctl -r > /dev/null 2>&1 || true

    # Let TLP handle CPU performance based on power source
    tlp-stat -s > /dev/null 2>&1 || true

    echo "$(date): Display woken, CPU performance restored" >> "$LOG_FILE"
fi
