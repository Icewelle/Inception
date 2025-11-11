#!/bin/sh
set -e

if [ -f /run/secrets/db_credentials ]; then
    . /run/secrets/db_credentials
fi

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"

    while ! mysqladmin ping --silent; do
        sleep 1
    done

    echo "Setting up root user and database..."
    mariadb -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    mysqladmin shutdown -uroot -p"${MYSQL_ROOT_PASSWORD}"
fi

exec mysqld --user=mysql --datadir=/var/lib/mysql