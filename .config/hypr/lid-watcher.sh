#!/bin/bash
# Reliable lid state watcher using polling

LOG_FILE="/tmp/lid-watcher.log"
STATE_FILE="/tmp/lid-last-state"

echo "$(date): Lid watcher started" >> "$LOG_FILE"

# Initialize last state
LAST_STATE="unknown"
if [ -f "$STATE_FILE" ]; then
    LAST_STATE=$(cat "$STATE_FILE")
fi

while true; do
    # Read current lid state
    if [ -f /proc/acpi/button/lid/LID0/state ]; then
        CURRENT_STATE=$(grep -o "open\|closed" /proc/acpi/button/lid/LID0/state)

        # Check if state changed
        if [ "$CURRENT_STATE" != "$LAST_STATE" ] && [ "$LAST_STATE" != "unknown" ]; then
            echo "$(date): Lid state changed: $LAST_STATE -> $CURRENT_STATE" >> "$LOG_FILE"

            # Run the lid handler
            ~/.config/hypr/lid-handler.sh
        fi

        # Save current state
        echo "$CURRENT_STATE" > "$STATE_FILE"
        LAST_STATE="$CURRENT_STATE"
    fi

    # Check every 0.5 seconds
    sleep 0.5
done
