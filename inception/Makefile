NAME=inception

LOGIN=keait-he
DATA_DIR= /home/$(LOGIN)/data

COMPOSE=docker compose -f srcs/docker-compose.yml

all: prepare build up

prepare:
	@echo "Creating persistent data directories in $(DATA_DIR)..."
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress

build: prepare
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

down:
	$(COMPOSE) down

restart: down up

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean: down
	docker system prune -af

fclean:
	$(COMPOSE) down -v --rmi all
	sudo rm -rf $(DATA_DIR)

re:	fclean all

.PHONY: all build prepare up start stop restart down logs ps clean fclean re
