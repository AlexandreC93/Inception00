FROM debian:bullseye

RUN apt update -y 

RUN apt update -y && apt install -y nginx

RUN apt install -y vim

RUN apt install -y curl

RUN mkdir -p /etc/nginx/ssl

RUN apt install -y openssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=PARIS/O=42/OU=42/CN=lcadinot.42.fr/UID=lcadinot"

RUN cp /etc/nginx/ssl/inception.crt /usr/local/share/ca-certificates/inception.crt

RUN update-ca-certificates

# Créer le répertoire pour les fichiers PID de NGINX
RUN mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf

# Définir les permissions pour le répertoire web
RUN chmod 755 /var/www/html

# Attribuer les permissions à l'utilisateur NGINX pour le répertoire web
RUN chown -R www-data:www-data /var/www/html

# Lancer NGINX au premier plan pour éviter l'arrêt du conteneur
CMD [ "nginx", "-g", "daemon off;" ]