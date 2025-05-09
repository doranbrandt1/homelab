# Home Lab Journal

## Day 1 - Ubuntu Server VM + Docker Setup
- Installed Ubuntu Server 24.04 in VirtualBox (2 CPUs, 2GB RAM, 25GB disk)
- Configured network as NAT + port forwarded 9000 for Portainer
- Installed Docker & Docker Compose
- Pulled and launched Portainer container
- Verified access at `localhost:9000`

## Next Steps:
- Deploy first containerized service
- Set up SSH access and public key auth
- Document entire architecture in repo

## 🗓️ May 9, 2025 - Jellyfin + Docker Compose Success (Almost)

**Major wins today:**
- Finalized SSH key setup for VM and successfully cloned/pulled `homelab` GitHub repo inside the Ubuntu Server VM.
- Installed Docker Compose plugin (`v2.35.1`) after troubleshooting missing package errors and repository config.
- Wrote and pushed `jellyfin.yml` to the root of the repo to simplify container orchestration.
- Ran `docker compose -f jellyfin.yml up -d` and confirmed container spun up with no errors.
- Verified that the Jellyfin container was listening inside the VM and UI loaded on `localhost:8096`.

**Setbacks:**
- Jellyfin UI launched but failed to connect to the internal server instance, likely due to missing VirtualBox **port forwarding rules**.
- Attempted to reboot and re-run container but issue persisted.
- GUI integration with the VM (copy/paste, mouse tracking) still not ideal — Guest Additions partially configured but not fully functional yet.

**Next Steps:**
- Fix VirtualBox network settings — confirm NAT is used and **8096:8096** TCP port is forwarded from host to guest.
- Test Jellyfin connection again from host browser after forwarding.
- Explore Bridged Networking later for improved visibility across devices.
- Set up media library inside `/media/movies` to test Jellyfin ingestion.

**Command Notes:**
- `docker compose -f jellyfin.yml up -d` — deploy container in detached mode
- `docker ps` — verify running containers
- `lsof -i -P -n | grep LISTEN` — check open ports inside VM
- `git pull --rebase` — sync with latest remote commits, maintaining a clean history

---
