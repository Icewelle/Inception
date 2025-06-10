.PHONY: build up down logs restart shell

build:
	echo "127.0.0.1 cluby.42.fr" | tee -a /etc/hosts
	docker compose -f srcs/docker-compose.yml build


up:
	docker compose -f 'srcs/docker-compose.yml' up -d --build 

down:
	docker compose -f srcs/docker-compose.yml down

logs:
	docker compose -f srcs/docker-compose.yml logs -f

reup: down up


restart:
	docker compose -f srcs/docker-compose.yml down
	docker compose -f srcs/docker-compose.yml up -d