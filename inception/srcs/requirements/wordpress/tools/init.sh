#!/bin/bash
set -e

cd /var/www/html

echo "=== Initialisation de WordPress ==="

echo "Attente de MariaDB..."
until mysqladmin ping -h mariadb -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent 2>/dev/null; do
    sleep 1
done
echo "MariaDB est pret."

if [ ! -f /usr/local/bin/wp ]; then
    echo "Installation de WP-CLI..."
    curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

if [ ! -f wp-load.php ]; then
    echo "Telechargement de WordPress..."
    wget -q https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    mv wordpress/* .
    rm -rf wordpress latest.tar.gz
fi

if [ ! -f wp-config.php ]; then
    echo "Creation de wp-config.php..."
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost=mariadb \
        --allow-root
fi

if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "Installation de WordPress..."
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    echo "Creation d'un utilisateur secondaire..."
    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root

    echo "WordPress installe avec succes."
else
    echo "WordPress deja installe, on passe l'installation."
fi

sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php/8.2/fpm/pool.d/www.conf

echo "=== Demarrage de PHP-FPM ==="
exec php-fpm8.2 -F
