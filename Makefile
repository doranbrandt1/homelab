# Define all compose files
COMPOSE_FILES = \
  -f docker-compose.yml \
  -f compose-files/jellyfin.yml \
  -f compose-files/portainer.yml \
  -f compose-files/npm.yml \
  -f compose-files/tautulli.yml

# Default up command
up:
	docker compose $(COMPOSE_FILES) up -d

down:
	docker compose $(COMPOSE_FILES) down

restart:
	docker compose $(COMPOSE_FILES) restart

logs:
	docker compose $(COMPOSE_FILES) logs -f

build:
	docker compose $(COMPOSE_FILES) pull

tautulli-up:
	docker compose -f compose-files/tautulli.yml up -d

tautulli-logs:
	docker compose -f compose-files/tautulli.yml logs -f

ps:
	docker compose $(COMPOSE_FILES) ps

backup:
	bash scripts/backup-data.sh

restore:
	bash scripts/restore-latest.sh

prune:
	bash scripts/prune-backups.sh

jellyfin-up:
	docker compose -f compose-files/jellyfin.yml up -d

jellyfin-down:
	docker compose -f compose-files/jellyfin.yml down

reset-jellyfin:
	docker stop jellyfin && docker rm jellyfin
	rm -rf compose-files/data/jellyfin
	mkdir -p compose-files/data/jellyfin/config compose-files/data/jellyfin/cache

homeassistant-up:
	docker compose -f compose-files/homeassistant.yml up -d

homeassistant-down:
	docker compose -f compose-files/homeassistant.yml down

homeassistant-logs:
	docker compose -f compose-files/homeassistant.yml logs -f

nextcloud-up:
	docker compose -f compose-files/nextcloud.yml up -d

nextcloud-down:
	docker compose -f compose-files/nextcloud.yml down

reset-nextcloud:
	docker stop nextcloud nextcloud-db || true
	docker rm nextcloud nextcloud-db || true
	rm -rf compose-files/data/nextcloud
	mkdir -p compose-files/data/nextcloud/html compose-files/data/nextcloud/db

show-env:
	@echo "Current .env Variables:" && echo && cat .env

mac-test:
	docker compose -f compose-files/portainer.yml -f compose-files/jellyfin.yml up -d

mac-down:
	docker compose -f compose-files/portainer.yml -f compose-files/jellyfin.yml down

restart-ha:
	docker restart home-assistant

health-check:
	docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | column -t

health:
	@python3 health_check.py

dashboard:
	@.venv/bin/python3 health_dashboard.py
