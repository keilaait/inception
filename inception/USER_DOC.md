# User Documentation

## 🚀 Starting the project

To start the Inception infrastructure, run:

	make
This command builds the Docker images and starts all required containers.
	The services started are:
 * NGINX (HTTPS entry point)
 * WordPress (PHP-FPM)
 * MariaDB (database)

## 🛑 Stopping the project

To stop all containers:

	make down
The Docker volumes are preserved, so data is not lost.

## 🌐 Accessing the website

The website is available through HTTPS:
	https://keait-he.42.fr
Because the project uses a self-signed TLS certificate, the browser may display a security warning during development.

## 🔐 WordPress administration panel

The WordPress administration interface is available at:	

	https://keait-he.42.fr/wp-admin
Use the administrator credentials created during installation.

## 👤 Managing credentials
Credentials are stored outside the Git repository.
They are defined through:
	.env variables
	Docker secrets
> Never commit passwords or sensitive information into Git.

## 🔎 Basic checks

Check running containers:
	docker ps

View container logs :
	docker logs <container_name>

Check docker ressources :
	docker volume ls
	docker network ls

# 🧹 Reset the project

To completely remove containers:
	make clean

To rebuild everything :
	make re
