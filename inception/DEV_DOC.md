```markdown

# Developer Documentation

## 📋 Prerequisites

Before starting the project, install:

- Docker
- Docker Compose
````

> Check the versions 

## 📁 Project structure

inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
	├── docker-compose.yml
	└── requirements/
	├── mariadb/
	├── nginx/
	└── wordpress/

## ⚙️ Environment configuration

Environment variables are stored inside:
	srcs/.env


The `.env` file must never be committed.

## 🏗️ Makefile commands

Build and start the project:
	make
Stop containers :
	make down
Rebuild images :
	make re
Remove containers and volumes :
	make clean

# 🐳 Docker Compose commands

Start services:
	docker compose -f srcs/docker-compose.yml up
Start in background :
	docker compose -f srcs/docker-compose.yml up -d
Stop services :
	docker compose -f srcs/docker-compose.yml down

## 💾 Data persistence

The project uses Docker volumes:
	* MariaDB data:
	/var/lib/mysql
	* Wordpress files :
	/var/www/html
Volumes keep data when containers are restarted.

## 🔧 Development workflow

After modifying a Dockerfile:
	make re
After modifying configuration files :
	docker compose up --build

## 🐞 Debugging

List containers:
	docker ps
Check logs :
	docker logs <container>
Access a container :
	docker exec -it <container> bash
