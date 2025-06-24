#!/bin/sh
set -e

mkdir -p /run/php

# Wait for MariaDB to be ready
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

# Configure wp-config.php
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

# Wait for wp core to be ready to install
if ! wp core is-installed --path="/var/www/html" --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url="${WORDPRESS_URL:-http://localhost}" \
        --title="${WORDPRESS_TITLE:-WordPress Site}" \
        --admin_user="${WORDPRESS_ADMIN_USER:-admin}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD:-admin}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL:-admin@example.com}" \
        --path="/var/www/html" \
        --allow-root
else
    echo "WordPress already installed."
fi

# Optional: Install plugins or themes
# echo "Installing plugins..."
# wp plugin install jetpack --activate --allow-root --path="/var/www/html"

# Start PHP-FPM or provided CMD
exec "$@"