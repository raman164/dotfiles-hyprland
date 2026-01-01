#!/bin/bash

# Automatic Backup System Setup Script for Arch Linux + Btrfs
# This script sets up Snapper to take automatic snapshots of your home directory

set -e

echo "=== Setting up Automatic Backup System with Snapper ==="
echo ""

# Step 1: Install packages
echo "[1/6] Installing Snapper and snap-pac..."
yay -S snapper snap-pac --needed

# Step 2: Unmount existing .snapshots if needed
echo ""
echo "[2/6] Preparing snapshot directory..."
if mountpoint -q /.snapshots; then
    sudo umount /.snapshots
fi

# Remove the directory if it exists
if [ -d "/.snapshots" ]; then
    sudo rmdir /.snapshots
fi

# Step 3: Create Snapper configuration for root
echo ""
echo "[3/6] Creating Snapper configuration for root..."
sudo snapper -c root create-config /

# Step 4: Delete the auto-created .snapshots subvolume and restore the mount
echo ""
echo "[4/6] Configuring snapshot subvolume..."
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots

# Step 5: Create Snapper configuration for home
echo ""
echo "[5/6] Creating Snapper configuration for home directory..."
sudo snapper -c home create-config /home

# Configure automatic snapshots for home
sudo snapper -c home set-config "TIMELINE_CREATE=yes"
sudo snapper -c home set-config "TIMELINE_LIMIT_HOURLY=5"
sudo snapper -c home set-config "TIMELINE_LIMIT_DAILY=7"
sudo snapper -c home set-config "TIMELINE_LIMIT_WEEKLY=0"
sudo snapper -c home set-config "TIMELINE_LIMIT_MONTHLY=0"
sudo snapper -c home set-config "TIMELINE_LIMIT_YEARLY=0"

# Configure automatic snapshots for root
sudo snapper -c root set-config "TIMELINE_CREATE=yes"
sudo snapper -c root set-config "TIMELINE_LIMIT_HOURLY=5"
sudo snapper -c root set-config "TIMELINE_LIMIT_DAILY=7"
sudo snapper -c root set-config "TIMELINE_LIMIT_WEEKLY=0"
sudo snapper -c root set-config "TIMELINE_LIMIT_MONTHLY=0"
sudo snapper -c root set-config "TIMELINE_LIMIT_YEARLY=0"

# Step 6: Enable and start Snapper services
echo ""
echo "[6/6] Enabling Snapper automatic snapshot services..."
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# Verify setup
echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Verification:"
sudo snapper -c root list
echo ""
sudo snapper -c home list
echo ""
echo "✓ Snapper is now configured!"
echo "✓ Automatic snapshots will be taken:"
echo "  - Every hour (keeps last 5)"
echo "  - Every day (keeps last 7)"
echo "✓ Snapshots before system updates (via snap-pac)"
echo ""
echo "Useful commands:"
echo "  snapper -c home list              # List all home snapshots"
echo "  snapper -c home create -d 'desc'  # Create manual snapshot"
echo "  snapper -c home delete NUM        # Delete snapshot"
echo "  snapper -c home undochange 1..2   # Undo changes between snapshots"
echo ""
echo "To restore files from a snapshot:"
echo "  cd /home/.snapshots/NUM/snapshot"
echo "  cp -r .config/nvim ~/               # Restore specific config"
