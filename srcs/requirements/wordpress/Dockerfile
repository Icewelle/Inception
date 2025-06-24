FROM alpine:3.19


# Install required packages
RUN apk update && apk upgrade && apk add --no-cache \
    php81 \
    php81-fpm \
    php81-mysqli \
    php81-json \
    php81-curl \
    php81-dom \
    php81-exif \
    php81-fileinfo \
    php81-mbstring \
    php81-openssl \
    php81-xml \
    php81-zip \
    php81-phar \
    php81-tokenizer \
    curl \
    mariadb-client

# Symlink php81 to php for WP-CLI compatibility
RUN ln -s /usr/bin/php81 /usr/bin/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM to listen on the network
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php81/php-fpm.d/www.conf && \
    sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php81/php-fpm.d/www.conf

# Set working directory for WordPress
WORKDIR /var/www/html

# Download and extract WordPress
RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xzf wordpress.tar.gz --strip-components=1 && \
    rm wordpress.tar.gz

# Create WordPress config from sample
RUN cp wp-config-sample.php wp-config.php

# Set permissions
RUN chown -R root:root /var/www/html

COPY init/init.sh /wp-init.sh
RUN chmod +x /wp-init.sh

# Expose PHP-FPM port
EXPOSE 9000

# Start PHP-FPM
ENTRYPOINT ["/wp-init.sh"]
CMD ["php-fpm81", "-F"]