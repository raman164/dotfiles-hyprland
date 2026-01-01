#!/bin/bash

# Quick Restore Script - Restore configs from Snapper snapshot

echo "=== Snapper Snapshot Restore Tool ==="
echo ""

# Show available snapshots
echo "Available snapshots of /home:"
snapper -c home list
echo ""

# Ask which snapshot to restore from
read -p "Enter snapshot number to restore from: " SNAPSHOT_NUM

if [ -z "$SNAPSHOT_NUM" ]; then
    echo "Error: No snapshot number provided"
    exit 1
fi

# Check if snapshot exists
if [ ! -d "/home/.snapshots/$SNAPSHOT_NUM/snapshot" ]; then
    echo "Error: Snapshot $SNAPSHOT_NUM does not exist"
    exit 1
fi

SNAPSHOT_PATH="/home/.snapshots/$SNAPSHOT_NUM/snapshot"
echo ""
echo "Snapshot path: $SNAPSHOT_PATH"
echo ""

# Show what's available in the snapshot
echo "Your home directory in this snapshot contains:"
ls -la "$SNAPSHOT_PATH/$USER/" | head -20
echo ""

# Interactive restore options
echo "What would you like to restore?"
echo "1) Specific config directory (e.g., .config/nvim)"
echo "2) All .config directories"
echo "3) Entire home directory (dangerous!)"
echo "4) Browse snapshot manually"
echo ""
read -p "Choose option (1-4): " OPTION

case $OPTION in
    1)
        read -p "Enter config path (e.g., .config/nvim): " CONFIG_PATH
        if [ -d "$SNAPSHOT_PATH/$USER/$CONFIG_PATH" ]; then
            read -p "This will overwrite ~/$CONFIG_PATH. Continue? (yes/no): " CONFIRM
            if [ "$CONFIRM" = "yes" ]; then
                cp -r "$SNAPSHOT_PATH/$USER/$CONFIG_PATH" ~/$(dirname "$CONFIG_PATH")/
                echo "✓ Restored $CONFIG_PATH"
            fi
        else
            echo "Error: Path not found in snapshot"
        fi
        ;;
    2)
        read -p "This will overwrite all .config directories. Continue? (yes/no): " CONFIRM
        if [ "$CONFIRM" = "yes" ]; then
            cp -r "$SNAPSHOT_PATH/$USER/.config"/* ~/.config/
            echo "✓ Restored all .config directories"
        fi
        ;;
    3)
        echo "WARNING: This is dangerous and not recommended!"
        read -p "Are you ABSOLUTELY sure? Type 'I UNDERSTAND': " CONFIRM
        if [ "$CONFIRM" = "I UNDERSTAND" ]; then
            read -p "Last chance. Type 'yes' to proceed: " FINAL
            if [ "$FINAL" = "yes" ]; then
                rsync -av --exclude='.snapshots' "$SNAPSHOT_PATH/$USER/" ~/
                echo "✓ Restored entire home directory"
            fi
        fi
        ;;
    4)
        echo "Opening snapshot directory in your file manager..."
        echo "Path: $SNAPSHOT_PATH/$USER"
        thunar "$SNAPSHOT_PATH/$USER" 2>/dev/null || xdg-open "$SNAPSHOT_PATH/$USER" 2>/dev/null || echo "Please manually browse: $SNAPSHOT_PATH/$USER"
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac

echo ""
echo "Done!"
