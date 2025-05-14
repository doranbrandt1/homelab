#!/bin/bash

# Load environment variables if .env exists
[ -f .env ] && export $(grep -v '^#' .env | xargs)

BACKUP_DIR="./backups"
MAX_BACKUPS=${MAX_BACKUPS:-5}  # fallback to 5 if not defined


echo "Pruning old backups, keeping only the $MAX_BACKUPS most recent..."

cd "$BACKUP_DIR" || { echo "Backup directory not found."; exit 1; }

TOTAL=$(ls data_backup_*.tar.gz 2>/dev/null | wc -l)

if [ "$TOTAL" -le "$MAX_BACKUPS" ]; then
  echo "Nothing to prune. Only $TOTAL backups present."
  exit 0
fi

# List all but the most recent N and delete them
ls -1t data_backup_*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | while read -r FILE; do
  echo "Deleting old backup: $FILE"
  rm "$FILE"
done

echo "Prune complete."
