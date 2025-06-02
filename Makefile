.PHONY: build up down logs restart shell

build:
	docker-compose -f srcs/docker-compose.yml build

up:
	docker-compose -f srcs/docker-compose.yml up -d -p 443

down:
	docker-compose -f srcs/docker-compose.yml down

logs:
	docker-compose -f srcs/docker-compose.yml logs -f

restart:
	docker-compose -f srcs/docker-compose.yml down
	docker-compose -f srcs/docker-compose.yml up -d

shell:
	docker-compose exec <service_name> /bin/sh