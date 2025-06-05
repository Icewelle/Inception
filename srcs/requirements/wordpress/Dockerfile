FROM php:8.2-fpm-alpine

RUN docker-php-ext-install mysqli
WORKDIR /var/www/
RUN apk add --no-cache curl \
    && curl -o wordpress.tar.gz https://wordpress.org/wordpress-6.7.tar.gz \
    && tar -xzf wordpress.tar.gz --strip-components=1 \
    && rm wordpress.tar.gz
#RUN chown -R www-data:www-data /var/www/wordpress
RUN chown -R www-data:www-data /var/www/html
EXPOSE 9000
CMD ["php-fpm"]