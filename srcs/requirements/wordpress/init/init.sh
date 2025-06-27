#!/bin/sh
set -e

if [ -f /run/secrets/db_credentials ]; then
    . /run/secrets/db_credentials
fi
if [ -f /run/secrets/wp_credentials ]; then
    . /run/secrets/wp_credentials
fi

mkdir -p /run/php

if [ ! -f /var/www/html/wp-load.php ]; then
    echo "Downloading WordPress core files..."
    php -d memory_limit=256M /usr/local/bin/wp core download --path=/var/www/html --allow-root

else
    echo "WordPress core files already present."
fi
echo "Waiting for MariaDB to be ready..."
for i in $(seq 1 30); do
    if mysql -h"${WORDPRESS_DB_HOST}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; then
        echo "MariaDB is ready!"
        break
    fi
    echo "Waiting for MariaDB... ($i/30)"
    sleep 2
    if [ "$i" -eq 30 ]; then
        echo "Warning: MariaDB did not become ready in time. Continuing anyway..."
    fi
done

WP_CONFIG_PATH="/var/www/html/wp-config.php"
if [ -f "$WP_CONFIG_PATH" ]; then
    rm -f /var/www/html/wp-config.php
fi

echo "Generating wp-config.php..."
wp config create \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="${MYSQL_PASSWORD}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --path="/var/www/html" \
    --allow-root

if ! wp core is-installed --path="/var/www/html" --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url="${WORDPRESS_URL}" \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --path="/var/www/html" \
        --allow-root
else
    echo "WordPress already installed."
fi

if ! wp user get "$WORDPRESS_USER" --path=/var/www/html > /dev/null 2>&1; then
  wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" --user_pass="$WORDPRESS_USER_PASSWORD" --role=author --path=/var/www/html
fi

exec "$@"