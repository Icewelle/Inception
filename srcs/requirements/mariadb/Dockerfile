FROM alpine:3.21

RUN apk update && apk upgrade && apk add --no-cache mariadb \
    mariadb-client

COPY conf/mariadb.conf /etc/my.cnf.d/mariadb-server.cnf
COPY conf/init.sh /init.sh
RUN chmod +x /init.sh
WORKDIR /var/lib/mysql
HEALTHCHECK --start-period=5m \
 CMD mariadb -e 'SELECT @@datadir;' || exit 1
ENTRYPOINT ["/init.sh"]
CMD ["mariadb"]