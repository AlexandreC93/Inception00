MAKEFLAGS += --no-print-directory

# Variables
DOCKER_COMPOSE = docker-compose
SRC_DIR = srcs
COMPOSE_FILE = $(SRC_DIR)/docker-compose.yml
DC = $(DOCKER_COMPOSE) -f $(COMPOSE_FILE)
DATA_DIR = $(HOME)/data

# Cibles
.PHONY: all build up down clean logs ps volumes inspect prune help eval net-ls info mysql


# Par défaut, exécuter les cibles build et up
all: build up

# Construire les images Docker et ajuster les permissions des répertoires
build:
	@ mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress > /dev/null 2>&1
	@$(DC) build

# Démarrer les conteneurs Docker
up:
	@$(DC) up -d

# Arrêter et supprimer les conteneurs Docker et le réseau
down:
	$(DC) down

# Nettoyer les volumes Docker et les données
clean:
	$(DC) down -v --remove-orphans
	sudo rm -rf $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress


# Afficher les journaux des conteneurs Docker
logs:
	$(DC) logs -f

# Afficher l'état des conteneurs Docker du projet
ps:
	$(DC) ps

# Lister les volumes Docker
volumes:
	docker volume ls

# Inspecter un volume Docker spécifique
inspect:
	@if [ -z "$(NAME)" ]; then \
		echo "Veuillez spécifier le nom du volume avec 'make inspect-volume NAME=volume_name'"; \
	else \
		docker volume inspect $(NAME); \
	fi

net-ls:
	docker network ls

# Ouvrir une session MySQL dans le conteneur MariaDB
mysql:
	docker exec -it mariadb mysql -u root -p

info:
	@echo "== Docker Network List =="
	@docker network ls
	@echo "\n== Docker Containers Status =="
	@if $(DC) ps | grep -q .; then \
		$(DC) ps; \
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
	@if $(DC) ps | grep -q .; then \
		$(DC) logs --tail=10; \
	else \
		echo "Aucun conteneur actif pour afficher les logs."; \
	fi
	@echo "\n== Docker Images List =="
	@if docker images | grep -q .; then \
		docker images; \
	else \
		echo "Aucune image Docker trouvée."; \
	fi; \

# Nettoyer tous les conteneurs, images, volumes et réseaux Docker (action destructrice)
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

# Afficher l'aide
help:
	@echo "Utilisation du Makefile :"
	@echo "  make                  : Construire et démarrer les conteneurs Docker"
	@echo "  make build            : Construire les images Docker"
	@echo "  make up               : Démarrer les conteneurs Docker"
	@echo "  make down             : Arrêter et supprimer les conteneurs Docker et le réseau"
	@echo "  make clean            : Nettoyer les volumes Docker et supprimer les données"
	@echo "  make logs             : Afficher les journaux des conteneurs Docker"
	@echo "  make ps               : Afficher l'état des conteneurs Docker du projet"
	@echo "  make volumes          : Lister les volumes Docker"
	@echo "  make inspect          : Inspecter un volume Docker spécifique (ex: make inspect-volume NAME=volume_name)"
	@echo "  make prune            : Nettoyer TOUT Docker (conteneurs, images, volumes, réseaux)"
	@echo "  make help             : Afficher cette aide"
	@echo "  make eval             : Afficher les testes"
	@echo "  make net-ls           : Lister les réseaux Docker"
	@echo "  make info             : Afficher les informations Docker"
	@echo "  make mysql            : Ouvrir une session MySQL dans le conteneur MariaDB"
