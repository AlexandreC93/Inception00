MAKEFLAGS += --no-print-directory

DOCKER_COMPOSE = docker-compose
SRC_DIR = srcs
COMP_FILE = $(SRC_DIR)/docker-compose.yml
CMD = $(DOCKER_COMPOSE) -f $(COMP_FILE)
DATA_DIR = $(HOME)/data

.PHONY: all build up down clean logs ps volumes inspect prune help eval net-ls info mysql


all: build up

build:
	@ mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress > /dev/null 2>&1
	@$(CMD) build

up:
	@$(CMD) up -d

down:
	$(CMD) down

clean:
	$(CMD) down -v --remove-orphans
	sudo rm -rf $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress


logs:
	$(CMD) logs -f

ps:
	$(CMD) ps

volumes:
	docker volume ls

inspect:
	@if [ -z "$(NAME)" ]; then \
		echo "Veuillez spécifier le nom du volume avec 'make inspect-volume NAME=volume_name'"; \
	else \
		docker volume inspect $(NAME); \
	fi

net-ls:
	docker network ls

mysql:
	docker exec -it mariadb mysql -u root -p

info:
	@echo "== Docker Network List =="
	@docker network ls
	@echo "\n== Docker Containers Status =="
	@if $(CMD) ps | grep -q .; then \
		$(CMD) ps; \
	else \
		echo "Aucun conteneur actif."; \
	fi
	@echo "\n== Docker Volumes List =="
	@if docker volume ls | grep -q .; then \
		docker volume ls; \
	else \
		echo "Aucun volume trouvé."; \
	fi
	@echo "\n== Inspecting Volume: mariadb =="
	@if docker volume inspect srcs_mariadb >/dev/null 2>&1; then \
		docker volume inspect srcs_mariadb; \
	else \
		echo "Le volume 'mariadb' n'existe pas."; \
	fi
	@echo "\n== Inspecting Volume: wordpress =="
	@if docker volume inspect srcs_wordpress >/dev/null 2>&1; then \
		docker volume inspect srcs_wordpress; \
	else \
		echo "Le volume 'wordpress' n'existe pas."; \
	fi
	@echo "\n== Docker Compose Logs =="
	@if $(CMD) ps | grep -q .; then \
		$(CMD) logs --tail=10; \
	else \
		echo "Aucun conteneur actif pour afficher les logs."; \
	fi
	@echo "\n== Docker Images List =="
	@if docker images | grep -q .; then \
		docker images; \
	else \
		echo "Aucune image Docker trouvée."; \
	fi; \

prune:
	@echo "ATTENTION : Cette action va supprimer TOUS les conteneurs, images, volumes et réseaux Docker sur votre système !"
	@read -p "Êtes-vous sûr de vouloir continuer ? [y/N] " confirm && \
	if [ "$$confirm" = "y" ]; then \
		if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa); fi; \
		if [ -n "$$(docker ps -qa)" ]; then docker rm $$(docker ps -qa); fi; \
		if [ -n "$$(docker images -qa)" ]; then docker rmi -f $$(docker images -qa); fi; \
		if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi; \
		if [ -n "$$(docker network ls -q)" ]; then docker network rm $$(docker network ls -q) 2>/dev/null || true; fi; \
		if [ -d "$(DATA_DIR)" ]; then sudo rm -rf $(DATA_DIR); fi; \
		docker system prune -a --volumes; \
	else \
		echo "Action annulée."; \
	fi