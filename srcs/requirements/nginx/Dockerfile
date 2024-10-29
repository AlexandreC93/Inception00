FROM alpine:latest

RUN apk update && apk add nginx openssl

# Configurer SSL
RUN openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
  -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=lcadinot.42.fr" \
  -keyout /etc/ssl/private/nginx-selfsigned.key \
  -out /etc/ssl/certs/nginx-selfsigned.crt

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]