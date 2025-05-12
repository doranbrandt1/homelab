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
