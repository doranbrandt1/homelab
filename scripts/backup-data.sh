#!/bin/bash

# Backup Variables
BACKUP_SRC="./data"
BACKUP_DEST="./backups"
DATE=$(date +"%Y-%m-%d_%H-%M")
BACKUP_NAME="data_backup_$DATE.tar.gz"

# Ensure backup destination exists
mkdir -p $BACKUP_DEST

# Create the archive
tar --no-overwrite-dir --no-same-owner -czvf "$BACKUP_DEST/$BACKUP_NAME" $BACKUP_SRC

echo "✅ Backup completed: $BACKUP_DEST/$BACKUP_NAME"
