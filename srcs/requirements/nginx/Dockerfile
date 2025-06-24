FROM alpine:3.21

RUN apk update
RUN apk add nginx
RUN apk add openssl
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=cluby.42.fr/UID=cluby"
COPY conf/nginx.conf /etc/nginx/nginx.conf
CMD [ "nginx", "-g", "daemon off;" ]

EXPOSE 443