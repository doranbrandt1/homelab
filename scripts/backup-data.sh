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

# Log backup creation
# Format date chunks
YEAR=$(date +'%Y')
MONTH=$(date +'%B')
WEEK=$(date +'%U')
DAY=$(date +'%Y-%m-%d')
TIME=$(date +'%H:%M')
LOG_FILE="./backups/backup-log.md"

# Make sure log file exists with header
if [ ! -f "$LOG_FILE" ]; then
  echo "# Backup Log" > "$LOG_FILE"
fi

# Week header
WEEK_HEADER="## Week of $(date -d "$DAY -$(date +%w) days" +'%B %d, %Y')"
grep -qxF "$WEEK_HEADER" "$LOG_FILE" || echo -e "\n$WEEK_HEADER" >> "$LOG_FILE"

# Day header
DAY_HEADER="### $DAY"
grep -qxF "$DAY_HEADER" "$LOG_FILE" || echo -e "\n$DAY_HEADER" >> "$LOG_FILE"

# Entry
echo " $TIME — Created $BACKUP_NAME" >> "$LOG_FILE"
