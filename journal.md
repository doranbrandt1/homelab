# Home Lab Journal

  ## May 8, 2025 Day 1 - Ubuntu Server VM + Docker Setup
  - Installed Ubuntu Server 24.04 in VirtualBox (2 CPUs, 2GB RAM, 25GB disk)
  - Configured network as NAT + port forwarded 9000 for Portainer
  - Installed Docker & Docker Compose
  - Pulled and launched Portainer container
  - Verified access at `localhost:9000`

    ### Next Steps:
    - Deploy first containerized service
    - Set up SSH access and public key auth
    - Document entire architecture in repo

---

## May 9, 2025 - Jellyfin + Docker Compose Success (Almost)

### Wins:
- Finalized SSH key setup for VM and successfully cloned/pulled `homelab` GitHub repo inside the Ubuntu Server VM.
- Installed Docker Compose plugin (`v2.35.1`) after troubleshooting missing package errors and repository config.
- Wrote and pushed `jellyfin.yml` to the root of the repo to simplify container orchestration.
- Ran `docker compose -f jellyfin.yml up -d` and confirmed container spun up with no errors.
- Verified that the Jellyfin container was listening inside the VM and UI loaded on `localhost:8096`.

### Opportunities:
- Jellyfin UI launched but failed to connect to the internal server instance, likely due to missing VirtualBox port forwarding rules.
- Attempted to reboot and re-run container but issue persisted.
- GUI integration with the VM (copy/paste, mouse tracking) still not ideal — Guest Additions partially configured but not fully functional yet.

### Docket:
- Fix VirtualBox network settings — confirm NAT is used and **8096:8096** TCP port is forwarded from host to guest.
- Test Jellyfin connection again from host browser after forwarding.
- Explore Bridged Networking later for improved visibility across devices.
- Set up media library inside `/media/movies` to test Jellyfin ingestion.

### Command Notes:
- `docker compose -f jellyfin.yml up -d` — deploy container in detached mode
- `docker ps` — verify running containers
- `lsof -i -P -n | grep LISTEN` — check open ports inside VM
- `git pull --rebase` — sync with latest remote commits, maintaining a clean history

---

## May 10, 2025 – Portainer Reset, Network Adaption

### Wins
- Deployed Portainer and confirmed UI access at `http://192.168.0.63:9000`
- Reset Portainer admin credentials and stored them securely
- Updated VirtualBox network to Bridged Adapter (IPv4: `192.168.0.63`)
- Verified LAN access to Jellyfin and Portainer
- Added Nginx Proxy Manager to `docker-compose.yml`
- Created and pushed:
  - `.env` – centralized environment variables
  - `.gitignore` – excluded sensitive/config paths
  - `services.md` – documented running stack
- Committed and pushed updates to GitHub using structured messages

### Docket:
- [ ] Log into Nginx Proxy Manager at `http://192.168.0.63:81`
- [ ] Change default credentials (`admin@example.com / changeme`)
- [ ] Create proxy routes:
  - [ ] `portainer.local`
  - [ ] `jellyfin.local`
- [ ] Update `hosts` file on Windows:
  ```plaintext
  192.168.0.63 jellyfin.local
  192.168.0.63 portainer.local
- [ ] Create homelab_net docker network to apply to services
  - [ ] Deploy next container: (either tautulli, ombi, homeassistant)

---

## May 12, 2025 – Day 3

### Wins
- Rebuilt missing `.env` with structured, pre-defined container ports
- Standardized all Docker volumes under a central `/data` directory
- Refactored `jellyfin.yml`, `portainer.yml`, `npm.yml`, and `tautulli.yml` with updated volume paths and shared `homelab_net`
- Created and committed a detailed `data/README.md` to document volume structure
- Added Tautulli service with future-proofed environment and config paths
- Introduced a powerful `Makefile` for orchestrating multi-compose deployments
- Cleaned up `.env`, tracked future service ports (Ombi, Home Assistant)
- Learned and documented **Conventional Commit** patterns for structured Git commits

### Opportunities / Next Steps
- Create `/data` backup system (versioned, weekly snapshots via `tar` or `rsync`)
- Add `make backup` command to Makefile for one-liner archiving
- Add `COMMIT_GUIDE.md` or repo onboarding doc for new contributors (or Future You™)
- Set up proxy hosts in Nginx Proxy Manager once login is created
- Begin container branching (e.g. `feature/ombi`) to isolate builds and testing
- Start logging container metrics into `/logs` or dashboard view (via Portainer or NPM)

### Notes & Commands

#### Volume Paths (Standardized)
```bash
- ./data/jellyfin/config:/config
- ./data/jellyfin/cache:/cache
- ./data/portainer/data:/data
- ./data/npm/data:/data
- ./data/npm/letsencrypt:/etc/letsencrypt
- ./data/tautulli/config:/config

#### Makefile Usage
- make up           # launch full stack
- make down         # stop all containers
- make restart      # restart everything
- make logs         # view combined logs
- make tautulli-up  # just run Tautulli

#### Git Workflow
- git add .
- git commit -m "chore: add Makefile for multi-compose orchestration"
- git push origin main

---

## May 13, 2025 – Backup System Locked In

### Wins
- Installed and configured WSL with Ubuntu for full bash support
- Built and tested a portable backup script (`backup-data.sh`) for the `/data` directory
- Created compressed `.tar.gz` snapshots stored in `/backups` with timestamped naming
- Handled common WSL extraction errors by updating the script with `--no-same-owner` and `--no-overwrite-dir` flags
- Added a `make backup` target to streamline snapshot creation from the Makefile
- Verified backup integrity and successful extraction into `test-restore/`

### Opportunities / Next Steps
- Add `make restore-latest` to simplify recovering from backup
- Add backup rotation to retain only the 5 most recent snapshots
- Create `scripts/README.md` to document backup usage
- Optionally generate a `backup-log.md` for tracking daily snapshot history

### Notes & Commands

#### Backup Creation
```bash
make backup

#### Backup Script Location
scripts/backup-data.sh

#### Test Archive Contents
tar -tzvf backups/data_backup_<timestamp>.tar.gz

#### Extract Backup to Folder
mkdir restore-test
tar --no-overwrite-dir --no-same-owner -xzvf backups/data_backup_<timestamp>.tar.gz -C restore-test

## May 14, 2025 – Home Assistant Integration & Proxy Setup

### Completed:
- Built and deployed Home Assistant container via Docker Compose
- Added `homeassistant.yml` to `compose-files/` with persistent config mount
- Established `home_net` bridge network for container interconnectivity
- Updated `.env` and `.env.example` with dynamic port/network vars
- Integrated HA with Nginx Proxy Manager (`npm.yml`)
- Patched multiple `Makefile` targets for HA (up, down, logs)
- Added `make show-env` for rapid environment debug output
- Cleaned up old Docker networks (`homeassistant_net`, etc.)
- Successfully verified container startup and port bindings

### Notes:
- Bug stemmed from mismatch between `${HA_NETWORK}` and declared `home_net`
- Environment variables in `networks:` block (YAML keys) are fragile across Compose versions
- Using hardcoded `home_net` simplifies proxy integration for now
- Home Assistant container confirmed accessible on local network
- `.env` still tracked locally only (ignored by Git per `.gitignore`)

### Next Up:
- Finalize Nginx Proxy Manager web access on port `81`
- Add first proxy host for Home Assistant UI
- Expand homelab services (e.g. MQTT, Tautulli routing)

---

## 2025-05-15 – Homelab Progress Log

### Highlights
- Reconfigured backup rotation system with dynamic retention via `.env`
- Docker Compose YAMLs refactored with shared external `home_net` network
- Fixed container-specific variables and logging under `make show-env`
- Initialized `homeassistant.yml` with working container network separation
- Resolved SSH push issue via WSL agent authentication

### Issues Faced
- Docker Compose failing due to conflicting network declarations (`network_mode` vs. `networks`)
- SSH permission denied when pushing from VS Code (resolved via WSL SSH agent)

### Next Steps
- Finalize Nginx Proxy Manager config
- Expose Home Assistant via NPM reverse proxy
- Plan for dynamic service routing and domain-based access

---