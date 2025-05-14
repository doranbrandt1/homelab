# Script Directory Overview

This directory contains utility scripts used for managing and automating homelab operations. Each script serves a specific role within the Docker/backup ecosystem.

---

## `backup-data.sh`
Creates a `.tar.gz` archive of the `/data` directory with a timestamped filename.

- Destination: `./backups/`
- Log: Appends to `backups/backup-log.md`
- Filename format: `data_backup_YYYY-MM-DD_HH-MM.tar.gz`
- Pulls backup retention count from `.env` (via `MAX_BACKUPS`)

---

## `prune-backups.sh`
Deletes older backup files in `./backups/`, keeping only the most recent N (default: 5).

- Reads `MAX_BACKUPS` from `.env` file if present
- Logs deletions via standard output

---

## `restore-latest.sh`
Restores the most recent backup file to a temporary `./restore-test/` directory for manual inspection or verification.

- Handles folder creation
- Uses flags to avoid permission and overwrite issues
- Extracts using `tar --no-overwrite-dir --no-same-owner`

---

## Future Additions
- `restore-to-live.sh` — Restore archive to active `/data` mount
- `snapshot-weekly.sh` — Dedicated weekly backup logic (alternate retention policy)
