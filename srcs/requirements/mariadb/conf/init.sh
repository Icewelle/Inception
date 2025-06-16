#!/bin/sh
set -e

# Initialize database if not already present
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
pid="$!"

# Wait for MariaDB to be ready
for i in $(seq 1 30); do
    if mariadb-admin ping --silent; then
        break
    fi
    sleep 1
done

# Run setup SQL
echo "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} ;" | mariadb
echo "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;" | mariadb
echo "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' ;" | mariadb
echo "FLUSH PRIVILEGES;" | mariadb

# Shutdown background MariaDB
mariadb-admin shutdown

# Start MariaDB in foreground
exec mysqld --user=mysql --datadir=/var/lib/mysql