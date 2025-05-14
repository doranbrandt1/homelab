#!/bin/bash

BACKUP_DIR="./backups"
RESTORE_DIR="./restore-test"

# Find the latest backup file
LATEST_BACKUP=$(ls -t $BACKUP_DIR/data_backup_*.tar.gz 2>/dev/null | head -n 1)

if [ -z "$LATEST_BACKUP" ]; then
  echo "No backup files found in $BACKUP_DIR"
  exit 1
fi

echo "Restoring from: $LATEST_BACKUP"

# Create restore directory if needed
mkdir -p "$RESTORE_DIR"

# Extract with safe flags
tar --no-overwrite-dir --no-same-owner -xzvf "$LATEST_BACKUP" -C "$RESTORE_DIR"

echo "Restore completed to $RESTORE_DIR"
