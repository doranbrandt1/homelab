# HomeLab Services

This file documents all Docker containers and their key configuration details.

---

## Jellyfin
- **Image:** jellyfin/jellyfin:latest
- **Ports:** 8096:8096
- **Volumes:** `./media/videos`, `./media/config`, `./media/cache`
- **Purpose:** Media streaming

## Nginx Proxy Manager
- **Image:** jc21/nginx-proxy-manager:latest
- **Ports:** 80, 81 (Admin UI), 443
- **Volumes:** `./nginx/data`, `./nginx/letsencrypt`
- **Purpose:** Reverse proxy and SSL management

## Portainer
- **Image:** portainer/portainer-ce
- **Ports:** 9000, 8000
- **Purpose:** Docker container dashboard

## qBittorrent (Planned)
- **Image:** linuxserver/qbittorrent
- **Ports:** 8080, 6881 (TCP/UDP)
- **Purpose:** Torrent client for automation

### Home Assistant

- **Container Name**: `homeassistant`
- **Compose File**: `compose-files/homeassistant.yml`
- **Ports**: Uses host networking (no explicit ports)
- **Volumes**:
  - `./homeassistant/config:/config`
  - `/etc/localtime:/etc/localtime:ro`
- **Network**: `home_net`
- **Notes**:
  - Accessible at `http://<VM-IP>:8123`
  - Requires persistent volume for config
  - `TZ` is passed in via `.env`

### Nextcloud
- Service: Nextcloud (Cloud Storage)
- Local URL: http://cloud.local
- Port: 8081 (host) → 80 (container)
- Proxy Host: cloud.local → nextcloud:80
- Volumes:
  - `compose-files/data/nextcloud/html:/var/www/html`
  - `compose-files/data/nextcloud/db:/var/lib/mysql`
