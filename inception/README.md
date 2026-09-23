_This project has been created as part of the 42 curriculum by keait-he._
---

## 📖 Description

**Inception** is a system administration and Docker project from the 42 curriculum.

The goal is to set up a small but functional web infrastructure using **Docker Compose**, entirely inside a virtual machine. Instead of using pre-built application images, each service is built from scratch using custom Dockerfiles.

The infrastructure exposes a **WordPress** website over HTTPS, served through **NGINX** as the sole entry point, backed by a **MariaDB** database. All persistent data is stored in named Docker volumes mapped to the host machine.

### Architecture Overview

                     HTTPS :443

                        |
                        v

                     NGINX
                (Web server + TLS)

                        |
                        |
                   FastCGI :9000

                        |
                        v

              WordPress + PHP-FPM
                (PHP application)

                        |
                        |
                     MySQL :3306

                        |
                        v

                     MariaDB
                    (Database)
---

# 🎯 Project Goals

The main objectives of this project are:

- Learn Docker fundamentals.
- Understand container orchestration with Docker Compose.
- Create custom Docker images.
- Configure a secure HTTPS web server.
- Understand the relationship between:
  - Web server
  - Application server
  - Database server
- Manage persistent data using Docker volumes.
- Learn basic system administration and deployment practices.

---

# 🐳 Docker Architecture

The project contains three containers:

## 🔐 NGINX Container

NGINX is the only public entry point of the infrastructure.

Responsibilities:

- Handle HTTPS connections.
- Manage TLS certificates.
- Serve static files.
- Forward PHP requests to WordPress through FastCGI.

Port exposed: 443/tcp

## 🌐 WordPress Container

WordPress runs with PHP-FPM.

Responsibilities:

- Execute PHP files.
- Manage the website.
- Communicate with MariaDB.
- Install WordPress automatically during first startup.

Port used internally: 9000/tcp

## 🗄️ MariaDB Container

MariaDB stores all WordPress data.

Responsibilities:

- Store users.
- Store website content.
- Provide database access to WordPress.

Port used internally: 3306/tcp


# 🚀 Instructions

## Prerequisites

The project requires:

- Linux environment
- Docker
- Docker Compose
- Make

---

# ✅ Instructions

## Requirements

The project requires:

- Linux environment
- Docker
- Docker Compose
- Make

## Project Structure

```
.
├── Makefile
├── docker-compose.yml
├── .env                        # Environment variables (not committed)
└── srcs/
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
	│   ├── tools/
        │   └── conf/
        │       └── nginx.conf
        ├── wordpress/
        │   ├── Dockerfile
	│   ├── conf/
        │   └── tools/
        │       └── init.sh
	└── mariadb/
            ├── Dockerfile
            ├── conf/
            └── tools/
                └── init.sh

```

## 🚀 Usage Instructions

### Build & Run

```bash
# Build all images and start the infrastructure
make

# Stop and remove all containers
make down

# Stop and remove all containers, networks, and volumes
make clean

# Full cleanup including built images (data)
make fclean

# Rebuild from scratch
make re
```

## 🌍 Access the Website

Once running, open your browser and navigate to:

```
https://keait-he.42.fr
````
to add it (if you're using digital ocean): 
	sudo nano /etc/hosts
then 
	IP_SERVER keait-he.42.fr

> Accept the self-signed TLS certificate warning on first visit.

## 🔧 Configuration

Before launching the project, create a `.env` file.
!! The .env file contains sensitive information and must never be committed.

## 🛠️ Useful Commands

### Docker Commands

	* docker ps
Displays active containers.
	* docker ps -a
Displays stopped and running containers.
	* docker logs <container>
Shows logs.
	* docker exec -it <container> bash
Opens a shell inside a container.
	* docker compose build
Builds images from Dockerfiles.
	* docker compose up
Starts containers and displays logs.
	* docker compose down
Stops and removes containers.
	* docker images
Shows Docker images stored locally.
	* docker volume ls
Shows persistent storage volumes.
	* docker network inspect 
Shows network

### Other Commands
	* curl ifconfig.me
Get the IP address
	* curl -k -I website
Check if we can access a website
	* docker exec -it mariadb mariadb -u root -p
Access the database in admin
	* SHOW DATABASES;
Shows all the bases 
	* USE <database_name>;
	* SHOW TABLES;
	* SELECT user_login FROM wp_users;
Check all wordpress users
	* sudo rm -rf /home/keait-he/data/wordpress/*
	* sudo rm -rf /home/keait-he/data/mariadb/*
Delete everything (to modify wordpress user)


# 📚 Good to Know

In this project, Docker is used *inside* a virtual machine to combine both: the VM provides a stable, isolated host environment, while Docker enables clean service separation and reproducibility.

This project uses a **custom bridge network** declared in `docker-compose.yml`. Only NGINX exposes port 443 to the outside world; WordPress and MariaDB are reachable only through the internal Docker network.

This project uses **two named volumes** whose data is stored at `/home/keait-he/data/` on the host:

- `wordpress_data` — WordPress source files
- mariadb_data` — MariaDB database files

---

# ✅ Instructions

## 🧠 Technical Choices

### 🖥️ Virtual Machines vs Docker

	* Virtual Machines
A virtual machine emulates a complete computer.
Each VM contains:
Operating system
Kernel
Libraries
Applications

Advantages
	✅ Strong isolation
	✅ Can run different operating systems
	✅ Complete environment separation

Disadvantages
	❌ Higher resource consumption
	❌ Slower startup time
	❌ Requires duplicate operating systems

	* Docker Containers
Docker containers share the host kernel but isolate applications.

Advantages
	✅ Lightweight
	✅ Fast startup
	✅ Easy deployment
	✅ Efficient resource usage

Disadvantages
	❌ Less isolation than virtual machines
	❌ Depends on the host kernel

> Docker is more suitable because the objective is to isolate services rather than emulate complete machines.

----

### 🌐 Docker Network vs Host Network

	* Docker Network
Containers communicate through an isolated Docker network.
> nginx → wordpress → mariadb

Advantages:
	✅ Service isolation
	✅ Internal communication
	✅ Better security

	* Host Network
The container directly uses the host network.

Advantages:
	✅ Simple configuration
	✅ Less overhead

Disadvantages:
	❌ Less isolation
	❌ Possible port conflicts

> Docker networks are used because only NGINX should be accessible from outside.

----

### 🔑 Secrets vs Environment Variables

	* Environment Variables
Environment variables store configuration values passed to containers.

Example:
	MYSQL_PASSWORD=your_password

Advantages
	✅ Easy to use
	✅ Simple Docker Compose integration
	✅ Good for development environments

Disadvantages
	❌ Sensitive information can be exposed

	* Docker Secrets
Docker secrets are designed for sensitive information.

Examples:
Passwords
Certificates
API keys

Advantages
	✅ More secure
	✅ Better access control

Disadvantages
	❌ More complex configuration

> Environment variables are used because they are required by the subject and are sufficient for this educational environment.

----

### 💾 Docker Volumes vs Bind Mounts

	* Docker Volumes
Volumes are managed by Docker.

Used for:
	MariaDB data
	WordPress files

Advantages:
	✅ Persistent data
	✅ Managed by Docker
	✅ Portable

	* Bind Mounts
Bind mounts connect a host folder directly to a container.

Advantages:
	✅ Easy access from host

Disadvantages:
	❌ Depends on host filesystem
	❌ Less portable

> Docker volumes are used because data must survive container recreation.

## General Knowledge

Different Servers
│
├── Port 22  → SSH (terminal)
├── Port 80  → HTTP (not secured website)
├── Port 443 → HTTPS (secured website)
├── Port 3306 → MariaDB
└── Port 9000 → PHP-FPM / WordPress

## 🎓 Evaluation Preparation (Technical Q&A)

Q1. What is a docker network?<br>

A1. A Docker network allows containers to communicate with each other without exposing their internal ports to the outside world.<br>
ss and NGINX are connected to the same bridge network, so WordPress can communicate with MariaDB using<br> 
he service name mariadb, and NGINX can communicate with WordPress using wordpress:9000.<br>

Q2. Explain SSL/TLS configuration

A2. NGINX is the only public entry point of the infrastructure. 
It listens only on port 443 using HTTPS. A self-signed TLS (Transport Layer Security)
certificate is generated during the image build and configured in nginx.conf. 
TLSv1.2 and TLSv1.3 are enabled. HTTP port 80 is not exposed, so the website cannot be accessed without encryption.

Q3. Why is port 80 not used?

A3. Port 80 is the default HTTP port. 
In this project, we only allow HTTPS traffic through port 443 because all communications must be
 encrypted using TLS. NGINX is the only entry point of the infrastructure.

---

## 📚 Resources and References

listing classic references related to the topic (documentation, articles, tutorials etc.), as well as a description of how AI was used specifying for which tasks and which parts of the project.
### Docker & Infrastructure

- [Docker official documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [PID 1 and signal handling in containers](https://cloud.google.com/architecture/best-practices-for-building-containers#signal-handling)
- [Docker Volumes documentation](https://docs.docker.com/storage/volumes/)
- [Docker Networking overview](https://docs.docker.com/network/)
- [Docker Secrets documentation](https://docs.docker.com/engine/swarm/secrets/)

### Services

- [NGINX documentation](https://nginx.org/en/docs/)
- [Configuring TLS in NGINX](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [WordPress CLI (WP-CLI)](https://wp-cli.org/)
- [PHP-FPM configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)

### Security

- [OWASP: Docker Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
- [Managing secrets in Docker](https://docs.docker.com/engine/swarm/secrets/)

---

## 🤖 AI Usage Disclosure

In accordance with 42 project directives, AI was used to assist in:

	-> Clarifying some Docker concepts.

	-> Reviewing code structure and optimization suggestions.

	-> Refining technical documentation.

	-> Identifying why services failed to start.

AI was *not* used to directly write core logic or replace understanding of the concepts — all generated suggestions were reviewed, tested, and adapted manually.
>>>>>>> 170db3a (new)
