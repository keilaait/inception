#!/bin/bash
set -e

MARKER="/var/lib/mysql/.inception_setup_done"

echo "=== Initialisation de MariaDB ==="

if [ ! -f "$MARKER" ]; then

    echo "Premiere initialisation : creation des fichiers systeme..."
    mysql_install_db \
        --user=mysql \
        --datadir=/var/lib/mysql \
        --auth-root-authentication-method=normal

    echo "Demarrage temporaire du serveur MariaDB..."
    mysqld_safe \
        --datadir=/var/lib/mysql \
        --skip-networking \
        --skip-syslog &

    echo "Attente que le serveur soit pret..."
    until mysqladmin ping --silent 2>/dev/null; do
        sleep 1
    done
    echo "Serveur pret."

    echo "Creation de la base et de l'utilisateur..."
    mysql -u root <<-EOSQL
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOSQL

    echo "Arret du serveur temporaire..."
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

    touch "$MARKER"
    echo "=== Initialisation terminee avec succes ==="
else
    echo "Base de donnees deja initialisee (marqueur trouve), on passe la configuration."
fi

echo "Demarrage du serveur MariaDB definitif..."
exec mysqld_safe \
    --datadir=/var/lib/mysql \
    --bind-address=0.0.0.0 \
    --skip-syslog
