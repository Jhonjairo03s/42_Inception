# Developer Documentation

This guide provides technical details for developers on how to set up, build, and manage the Inception infrastructure, as well as an overview of the data persistence strategy.

## Setting Up the Environment from Scratch

### Prerequisites
- A Linux environment (Ubuntu/Debian recommended or a 42 VM).
- **Docker Engine** and **Docker Compose (v2)** installed.
- `make` installed.
- Local domain mapping: You must add `127.0.0.1 jhvalenc.42.fr` to your `/etc/hosts` file to correctly route traffic to the local NGINX server.

### Configuration Files and Secrets
All secrets and environment variables are strictly passed through a `.env` file. You must create a `.env` file inside the `srcs/` directory before building the project. 

Required variables include:
```env
# Database configurations
MYSQL_DATABASE=inception
MYSQL_USER=user
MYSQL_PASSWORD=secret
MYSQL_ROOT_PASSWORD=root_secret

# WordPress configurations
DOMAIN_NAME=jhvalenc.42.fr
WP_TITLE=Inception
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin_secret
WP_ADMIN_EMAIL=admin@42.fr
WP_USER=editor
WP_PASSWORD=editor_secret
WP_EMAIL=editor@42.fr
```

## Building and Launching the Project
The project utilizes a `Makefile` to orchestrate the `docker-compose.yml` file.

- **`make` (or `make all`)**: Creates the host volumes directories at `/home/<login>/data/` and runs `docker compose up -d --build`. This compiles the custom Alpine images and starts the detached containers.
- **`make clean`**: Executes `docker compose down`, stopping and removing containers, networks, and anonymous volumes.
- **`make fclean`**: Performs a hard reset. It stops the containers, forcefully removes the persistent data directories on the host (`rm -rf`), and aggressively prunes the Docker system (removing all unused images and volumes).
- **`make re`**: Executes `fclean` followed by `all`, providing a completely fresh installation.

## Relevant Docker Commands for Management
To manage and debug the infrastructure during development, use the following commands:
- **View live logs of a specific service:** `sudo docker logs -f <container_name>` (e.g., `sudo docker logs -f wordpress`).
- **Enter a running container shell:** `sudo docker exec -it <container_name> sh`
- **Inspect network connectivity:** `sudo docker network inspect srcs_inception_net`

## Project Data and Persistence Strategy
Instead of using direct bind mounts (which are strictly forbidden by the subject) or standard isolated volumes, the named volumes (`db_data` and `wp_data`) are configured using the `local` driver with specific `driver_opts`. This architecture forces Docker to map these named volumes directly to the host's physical directories (`/home/login/data/mariadb` and `/home/login/data/wordpress`). This guarantees that databases and website files persist across container rebuilds and host reboots, fulfilling all requirements.

**How it persists:** Because these directories are physically located on the host's filesystem, stopping or removing the containers (`make clean`) does not affect the data. When the containers are rebuilt and restarted, they remount these host directories and instantly regain access to the previous state of the database and website files.
