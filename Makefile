MAKEFLAGS += --no-print-directory

DOCKER_COMPOSE = docker-compose
SRC_DIR = srcs
COMP_FILE = $(SRC_DIR)/docker-compose.yml
CMD = $(DOCKER_COMPOSE) -f $(COMP_FILE)
DATA_DIR = $(HOME)/data

.PHONY: all build up down clean logs ps volumes prune net-ls mysql


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

net-ls:
	docker network ls

mysql:
	docker exec -it mariadb mysql -u root -p

prune:

	if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa); fi; \
	if [ -n "$$(docker ps -qa)" ]; then docker rm $$(docker ps -qa); fi; \
	if [ -n "$$(docker images -qa)" ]; then docker rmi -f $$(docker images -qa); fi; \
	if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi; \
	if [ -n "$$(docker network ls -q)" ]; then docker network rm $$(docker network ls -q) 2>/dev/null || true; fi; \
	if [ -d "$(DATA_DIR)" ]; then sudo rm -rf $(DATA_DIR); fi; \
	docker system prune -a --volumes; \
