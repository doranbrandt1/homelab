# folder - /data – Persistent Docker Volume Storage

This folder contains all persistent container data used in the HomeLab stack.

---

## Service Volume Structure

### Jellyfin
- `/data/jellyfin/config` → Container `/config`
- `/data/jellyfin/cache` → Container `/cache`

### Portainer
- `/data/portainer/data` → Container `/data`

### Nginx Proxy Manager
- `/data/npm/data` → Container `/data`
- `/data/npm/letsencrypt` → Container `/etc/letsencrypt`

### Tautulli
- `/data/tautulli/config` → Container `/config`

---

## Notes
- Each service has its own subfolder for easy backups and volume management
- Avoid naming collisions by sticking to lowercase service names
- All containers are attached to the shared Docker network `homelab_net`