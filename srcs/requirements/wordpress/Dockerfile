FROM alpine:3.21


# Install required packages
RUN apk update && apk upgrade && apk add --no-cache \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-json \
    php83-curl \
    php83-dom \
    php83-exif \
    php83-fileinfo \
    php83-mbstring \
    php83-openssl \
    php83-xml \
    php83-zip \
    php83-phar \
    php83-tokenizer \
    curl \
    mariadb-client

# Symlink php83 to php for WP-CLI compatibility
#RUN ln -s /usr/bin/php83 /usr/bin/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM to listen on the network
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php83/php-fpm.d/www.conf && \
    sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php83/php-fpm.d/www.conf

# Set working directory for WordPress
WORKDIR /var/www/html

# Download and extract WordPress
RUN curl -o wordpress.tar.gz https://wordpress.org/wordpress-6.7.tar.gz && \
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
CMD ["php-fpm83", "-F"]