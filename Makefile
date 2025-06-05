.PHONY: build up down logs restart shell

build:
	
	docker-compose -f srcs/docker-compose.yml build


up:
	docker compose -f 'srcs/docker-compose.yml' up -d --build 

down:
	docker-compose -f srcs/docker-compose.yml down

logs:
	docker-compose -f srcs/docker-compose.yml logs -f

reup: down build up


restart:
	docker-compose -f srcs/docker-compose.yml down
	docker-compose -f srcs/docker-compose.yml up -d