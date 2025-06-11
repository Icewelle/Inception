#!/bin/sh
set -e

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
for i in $(seq 1 30); do
    if mysql -h${WORDPRESS_DB_HOST} -u${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1" >/dev/null 2>&1; then
        echo "MariaDB is ready!"
        break
    fi
    echo "Waiting for MariaDB... ($i/30)"
    sleep 2
    if [ $i -eq 30 ]; then
        echo "Warning: MariaDB did not become ready in time. Continuing anyway..."
    fi
done

# Update WordPress configuration
sed -i "s/database_name_here/${MYSQL_DATABASE}/g" /var/www/html/wp-config.php
sed -i "s/username_here/${MYSQL_USER}/g" /var/www/html/wp-config.php
sed -i "s/password_here/${MYSQL_PASSWORD}/g" /var/www/html/wp-config.php
sed -i "s/localhost/${WORDPRESS_DB_HOST}/g" /var/www/html/wp-config.php

# Start PHP-FPM
exec "$@"