NAME = inception

DOCKER_COMPOSE	= docker-compose -f ./srcs/docker-compose.yml
COMPOSE_DIR	= ./srcs

# ─────────────────────────────────────────────────────────────────────────────
# Commands
# ─────────────────────────────────────────────────────────────────────────────

all: up

up:
	@echo "🔧 Lancement des containers..."
	@$(DOCKER_COMPOSE) up --build
down:
	@echo "🧹 Arrêt et suppression des containers..."
	@$(DOCKER_COMPOSE) down

clean:
	@echo "🧹 Suppression des containers et des volumes..."
	docker system prune -af --volumes
fclean: clean
	@echo "🧹 Suppression des images..."
	@docker rmi mariadb wordpress nginx || true
	@echo "🧹 Suppression du volume local..."
	@rm -rf /home/${USER}/data/*

re: fclean all

.PHONY: all up down clean fclean re
