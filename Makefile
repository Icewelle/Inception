all: build

build:
	grep -q "127.0.0.1 cluby.42.fr" /etc/hosts || echo "127.0.0.1 cluby.42.fr" | tee -a /etc/hosts
	docker compose -f srcs/docker-compose.yml up -d --build

clean:
	docker compose -f srcs/docker-compose.yml down -v

fclean: clean
	docker system prune -af
	docker volume prune -af

re : fclean all

logs:
	docker compose -f srcs/docker-compose.yml logs -f

privilege:
	@docker run --rm -it --privileged -v /home/cluby:/host ubuntu bash

.PHONY: build clean fclean re logs privilege