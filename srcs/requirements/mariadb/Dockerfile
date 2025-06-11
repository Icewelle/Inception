FROM alpine:3.19

RUN apk update && apk upgrade && apk add --no-cache mariadb
RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    chmod 777 /run/mysqld
COPY conf/mariadb.conf /etc/my.cnf.d/mariadb-server.cnf
COPY conf/init.sh /init.sh
RUN chmod +x /init.sh
WORKDIR /var/lib/mysql
EXPOSE 3306
LABEL version="1.0"
LABEL description="MariaDB Server"
HEALTHCHECK --start-period=5m \
 CMD mariadb -e 'SELECT @@datadir;' || exit 1
EXPOSE 3306
ENTRYPOINT ["/init.sh"]
CMD ["mariadbd"]