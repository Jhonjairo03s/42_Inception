*This project has been created as part of the 42 curriculum by jhvalenc.*

# Inception

## Description
Inception is a System Administration and DevOps project aimed at broadening knowledge of network and system architecture using Docker. The goal is to build a complete, containerized web infrastructure from scratch, operating inside a dedicated virtual machine. 

The infrastructure is composed of specific services running in their own isolated containers:
- A **MariaDB** database.
- A **WordPress** site served by `php-fpm`.
- An **NGINX** web server acting as the only entry point, securing traffic via TLS 1.2/1.3.
- **Bonus:** A **Redis** cache server to optimize WordPress performance.

**Main Design Choices & Use of Docker:**
Instead of using ready-made images from DockerHub, this project strictly requires building custom images from a lightweight base OS. **Alpine Linux** was chosen for all containers due to its minimal footprint and enhanced security. Docker is used to orchestrate these microservices, allowing them to communicate via an isolated internal network (`inception_net`) while ensuring that each service runs as a foreground process (PID 1) without the use of background daemons or multiplexers like `systemd`. 

## Technical Choices & Comparisons

### Virtual Machines vs Docker
- **Virtual Machines (VMs)** emulate an entire hardware system, requiring a full guest operating system. They are heavy, take minutes to boot, and consume significant RAM/CPU.
- **Docker Containers** virtualize only the OS kernel. They share the host's kernel but keep applications and their dependencies isolated. They are lightweight, boot in seconds, and use minimal resources.

### Secrets vs Environment Variables
- **Environment Variables** are standard key-value pairs passed to a container at runtime (e.g., via a `.env` file). While convenient, they can be exposed in logs or via inspection tools if not handled carefully.
- **Docker Secrets** are a more secure, encrypted mechanism natively provided by Docker Swarm. They mount sensitive data (like passwords) into containers as temporary, in-memory files rather than environment variables, keeping them hidden from standard debugging tools.

### Docker Network vs Host Network
- **Host Network** removes network isolation between the container and the Docker host. The container uses the host's IP and ports directly, which can lead to port conflicts and security risks.
- **Docker Network (Bridge)** creates an isolated, internal private network. Containers communicate securely using DNS resolution based on container names (e.g., WordPress securely connects to `mariadb:3306`), and only explicitly published ports (like NGINX's 443) are exposed to the outside world.

### Docker Volumes vs Bind Mounts
- **Docker Volumes** are managed entirely by Docker within its internal storage directory (`/var/lib/docker/volumes`). They are easier to back up and abstract away the host's filesystem.
- **Bind Mounts** map a specific, user-defined path on the host machine (e.g., `/home/jhonjairo03s/data`) directly into the container. This project uses bind mounts to ensure database and website data persists predictably on the host, even if Docker is completely purged.

## Instructions
1. Clone the repository.
2. Ensure your host machine resolves the domain `jhvalenc.42.fr` to `127.0.0.1` (edit `/etc/hosts`).
3. Place your configured `.env` file at `srcs/.env`.
4. Run the project using the provided Makefile:
   ```bash
   make
   ```
5. To stop the infrastructure: `make clean`
6. To completely wipe containers and data volumes: `make fclean`

## Resources
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Alpine Linux Package Management](https://wiki.alpinelinux.org/wiki/Alpine_Package_Keeper)
- [WP-CLI Documentation](https://make.wordpress.org/cli/handbook/)
- [NGINX Reverse Proxy Guide](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)

**Artificial Intelligence Usage:**
AI (Gemini) was utilized as an interactive SysAdmin coach during the development of this project. It was specifically used for:
- Debugging Alpine-specific package constraints (e.g., identifying the need for `php85-tokenizer` for WP-CLI and resolving `php-fpm` syntax errors).
- Troubleshooting MariaDB socket initialization issues (`/run/mysqld` permissions).
- Providing low-level explanations on network resolution issues (`skip-name-resolve`) between Docker containers.
- Refining the `Makefile` to safely automate the creation and destruction of root-owned bind mounts.
