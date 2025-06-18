#!/bin/bash

# Find PHP binary
PHP_BIN=$(which php || find /usr/local -name php -type f | head -n 1)

if [ -z "$PHP_BIN" ]; then
    echo "ERROR: PHP not found!"
    exit 1
fi

# Use the found PHP for WP-CLI
export WP_CLI_PHP="$PHP_BIN"

echo "Setup script started at $(date)"
# Wait until wp-config.php is properly configured
until $(grep -q "DB_NAME" /var/www/html/wp-config.php) && $(grep -q "${MYSQL_DATABASE}" /var/www/html/wp-config.php); do
    echo "Waiting for wp-config.php to be configured..."
    sleep 2
done

# Check if WordPress is already installed
if ! wp core is-installed --path=/var/www/html --allow-root; then
    echo "Installing WordPress..."
    
    # Install WordPress
    wp core install \
        --path=/var/www/html \
        --url="${DOMAIN:-localhost}" \
        --title="${SITE_TITLE:-WordPress Site}" \
        --admin_user="${WP_ADMIN_USER:-admin}" \
        --admin_password="${WP_ADMIN_PASSWORD:-admin}" \
        --admin_email="${WP_ADMIN_EMAIL:-admin@example.com}" \
        --skip-email \
        --allow-root
    
    # Optional: Install a theme
    # wp theme install twentytwentytwo --activate --allow-root
    
    # Optional: Install plugins
    # wp plugin install akismet --activate --allow-root
    
    echo "WordPress installation complete!"
else
    echo "WordPress is already installed. Skipping installation."
fi