FROM php:8.2-fpm-alpine

# Install only the mysqli extension (required for WordPress to connect to MySQL/MariaDB)
RUN docker-php-ext-install mysqli

# Set working directory
WORKDIR /var/www/html

# Download and extract WordPress
RUN apk add --no-cache curl \
    && curl -o latest.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz
#COPY ./readme.html ./test/test.html
# Set permissions (so PHP can write files)
RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000
CMD ["php-fpm"]