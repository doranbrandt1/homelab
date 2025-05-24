# Proxy Config Notes – Homelab

## Nginx Proxy Manager – Configuration Overview

### Domain: `homeassistant.local`
- **Scheme**: HTTP
- **Forward Hostname/IP**: `home-assistant`
- **Forward Port**: `8123`
- **Websockets Enabled**: yes
- **Block Common Exploits**: yes
- **Access List**: Publicly Accessible

### SSL Tab Settings (Localhost Context)
- **SSL Certificate**: `None`
- **Force SSL**: no
- **HTTP/2 Support**: no
- **HSTS Options**: no

> Reason: Local network reverse proxy without a public certificate authority. Avoid forcing SSL unless remote HTTPS is configured.

---

## Trusted Proxy Setup (configuration.yaml)

```
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.24.0.2
  ip_ban_enabled: false
```

> `172.24.0.2` is the Nginx Proxy Manager container's IP in the `home_net` bridge.

---

## Docker Commands Used

```bash
# View NPM container IP (for trusted proxy)
docker network inspect home_net

# Restart HA for config changes
make restart-ha

# Logs for HA debug
docker logs home-assistant | grep -i "host"
```

---

## Completed Status
- Home Assistant accessible at: http://homeassistant.local
- Websocket support enabled
- NGINX forwarding working