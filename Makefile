LOGIN = jhonjairo03s
DATA_PATH = /home/$(LOGIN)/data
COMPOSE_FILE = ./srcs/docker-compose.yml

all:
	mkdir -p $(DATA_PATH)/mariadb/
	mkdir -p $(DATA_PATH)/wordpress/
	@sudo docker-compose -f $(COMPOSE_FILE) up -d --build 

clean:
	@sudo docker-compose -f $(COMPOSE_FILE) down

fclean: clean
	sudo rm -rf $(DATA_PATH)/mariadb/*
	sudo rm -rf $(DATA_PATH)/wordpress/*
	@sudo docker system prune -a --volumes -f

re: fclean all

.PHONY: all clean fclean re
