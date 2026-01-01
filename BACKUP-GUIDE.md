# Backup & Restore Guide

## What Happened Yesterday?

When we ran `git reset --hard`, it **permanently deleted** all your uncommitted configuration changes. You lost:
- Custom Hyprland configs
- Neovim settings
- Waybar customizations
- All other dotfile modifications

**This won't happen again with Snapper snapshots!**

---

## The Solution: Snapper (Automatic Btrfs Snapshots)

### What is Snapper?

Snapper automatically takes snapshots of your filesystem using btrfs. Think of it as "time machine" for your configs.

### How It Works

1. **Automatic Hourly Snapshots** - Saves your /home every hour (keeps last 5)
2. **Automatic Daily Snapshots** - Saves daily (keeps last 7)
3. **Pre/Post Package Updates** - Snapshots before ANY system update via pacman
4. **Manual Snapshots** - Create anytime before risky operations

---

## Setup Instructions

### 1. Run the Setup Script

```bash
chmod +x ~/setup-backup-system.sh
./setup-backup-system.sh
```

This will:
- Install Snapper and snap-pac
- Configure automatic snapshots
- Enable hourly/daily backups
- Enable pre-update snapshots

### 2. Verify It's Working

```bash
# List snapshots
snapper -c home list

# Check if services are running
systemctl status snapper-timeline.timer
systemctl status snapper-cleanup.timer
```

---

## Daily Usage

### Creating Manual Snapshots (Before Risky Changes)

**ALWAYS do this before:**
- Editing important configs
- Running git commands
- System updates
- Installing new software

```bash
# Quick snapshot
snapper -c home create -d "Before editing configs"

# With cleanup algorithm
snapper -c home create -c timeline -d "Before major changes"
```

### Listing Snapshots

```bash
# List all snapshots
snapper -c home list

# Shows: Number | Type | Date | Description
#        1      | single | today 14:30 | timeline
#        2      | single | today 15:30 | Before editing configs
```

### Restoring from Snapshots

#### Option 1: Use the Restore Script (Easiest)

```bash
chmod +x ~/restore-from-snapshot.sh
./restore-from-snapshot.sh
```

Follow the interactive prompts to:
- View available snapshots
- Choose what to restore
- Confirm before overwriting

#### Option 2: Manual Restore (More Control)

```bash
# 1. List snapshots
snapper -c home list

# 2. Browse a snapshot
cd /home/.snapshots/2/snapshot/$USER

# 3. Copy what you need
cp -r .config/nvim ~/.config/
cp -r .config/hypr ~/.config/
cp .zshrc ~/

# 4. Or use diff to see what changed
snapper -c home diff 1..2
```

#### Option 3: Rollback Everything (Nuclear Option)

```bash
# Rollback to snapshot 2
snapper -c home undochange 1..2

# WARNING: This undoes ALL changes between snapshots!
```

---

## Preventing Yesterday's Disaster

### Before ANY Risky Git Operation

```bash
# 1. Create snapshot
snapper -c home create -d "Before git operations"

# 2. Do your git work
git reset --hard HEAD  # or whatever

# 3. If something goes wrong:
./restore-from-snapshot.sh
```

### Workflow Example

```bash
# Morning: Check what you have
snapper -c home list

# Before making changes
snapper -c home create -d "Before experimenting with waybar"

# Make your changes...
# Edit configs...
# Test...

# Oops, broke something!
# Restore from the snapshot you just made
./restore-from-snapshot.sh
# Select the "Before experimenting" snapshot
# Choose to restore .config/waybar
```

---

## Automation Schedule

Once set up, Snapper automatically creates:

| Frequency | Retention | When                          |
|-----------|-----------|-------------------------------|
| Hourly    | Keep 5    | Every hour (e.g., 14:00, 15:00) |
| Daily     | Keep 7    | Every day at midnight         |
| Pre-update| Keep 5    | Before every pacman update    |

**This means:**
- You can always go back 5 hours
- You can always go back 7 days
- Every system update has a "before" snapshot

---

## Advanced Commands

### Compare Snapshots

```bash
# See what changed between snapshots 1 and 2
snapper -c home diff 1..2

# See what changed in specific directory
snapper -c home diff 1..2 .config/nvim
```

### Cleanup Old Snapshots

```bash
# Delete specific snapshot
snapper -c home delete 5

# Cleanup old snapshots automatically (already runs via timer)
snapper -c home cleanup timeline
```

### Modify Retention Policy

```bash
# Keep 10 hourly instead of 5
sudo snapper -c home set-config "TIMELINE_LIMIT_HOURLY=10"

# Keep 30 daily instead of 7
sudo snapper -c home set-config "TIMELINE_LIMIT_DAILY=30"
```

---

## Storage Considerations

### How Much Space?

Btrfs snapshots use **copy-on-write**, meaning:
- Initial snapshot: ~0 GB (just metadata)
- After changes: Only stores the differences
- Very space-efficient!

### Check Snapshot Space Usage

```bash
# See filesystem usage
df -h /home

# See snapshot sizes
sudo btrfs filesystem du -s /home/.snapshots/*/snapshot
```

### Cleanup Strategy

The automatic cleanup timer will:
- Delete snapshots older than the retention policy
- Keep the most recent snapshots
- Free up space automatically

---

## Emergency Recovery

### If Your System Won't Boot

1. Boot from Arch Linux USB
2. Mount your btrfs partition
3. List snapshots: `ls /mnt/home/.snapshots/`
4. Copy files from snapshot to restore

### If You Accidentally Deleted Everything

```bash
# Find the most recent snapshot
snapper -c home list

# Restore from it
cd /home/.snapshots/<NUMBER>/snapshot/$USER
cp -r * ~/
```

---

## Quick Reference Card

```bash
# CREATE SNAPSHOT BEFORE RISKY WORK
snapper -c home create -d "description"

# LIST ALL SNAPSHOTS
snapper -c home list

# EASY RESTORE (interactive)
./restore-from-snapshot.sh

# QUICK RESTORE (manual)
cp -r /home/.snapshots/NUM/snapshot/$USER/.config/nvim ~/.config/

# DELETE SNAPSHOT
snapper -c home delete NUM

# COMPARE SNAPSHOTS
snapper -c home diff NUM1..NUM2
```

---

## Integration with Your Workflow

### Add to .zshrc

Add these aliases for quick access:

```bash
# Add to ~/.zshrc
alias snap-create='snapper -c home create -d'
alias snap-list='snapper -c home list'
alias snap-restore='~/restore-from-snapshot.sh'
alias snap-diff='snapper -c home diff'

# Usage:
# snap-create "Before testing"
# snap-list
# snap-restore
```

---

## Summary

**What you get:**
- ✅ Automatic backups every hour (last 5 hours recoverable)
- ✅ Daily backups (last 7 days recoverable)
- ✅ Snapshot before every system update
- ✅ Easy restore with script or manual copy
- ✅ Minimal disk space usage
- ✅ Never lose configs again!

**What happened yesterday will NEVER happen again** because you can always restore from the last hourly snapshot.
