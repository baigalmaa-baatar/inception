# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bbaatar <bbaatar@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/09/23 14:01:43 by bbaatar           #+#    #+#              #
#    Updated: 2022/09/23 14:01:45 by bbaatar          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DOCKER = 'docker'
DOCKER_COMPOSE = 'docker-compose'

DOCKER_COMPOSE_FILE = './srcs/docker-compose.yml'

CONTAINER_MARIADB = mariadb
CONTAINER_NGINX = nginx
CONTAINER_WORDPRESS = wordpress

.PHONY: default
default: build ;

clear_all: clear_containers clear_images

clear_containers:
	$(DOCKER) stop `$(DOCKER) ps -a -q` && $(DOCKER) rm `$(DOCKER) ps -a -q`

clear_images:
	$(DOCKER) rmi -f `$(DOCKER) images -q`

build: ## Build image and start all containers in background
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d --build

up: ## Start all containers in background
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d

status: ## Show status of containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) ps

restart: ## Restart all containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) stop
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d

logs: ## Show logs for all containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) logs --tail=100 -f

down: ##Clean all data stop containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down

fclean:
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force