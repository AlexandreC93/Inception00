FROM debian:bullseye

RUN apt-get update -y

RUN apt-get upgrade -y

# Installer wget pour télécharger des fichiers
RUN apt-get install -y wget

# Installer PHP 7.4, PHP-FPM, et le module PHP pour MySQL
RUN apt-get install -y php7.4 php-fpm php-mysql

# Installer WP-CLI pour la gestion de WordPress en ligne de commande
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Installer le client MySQL par défaut pour les opérations sur la base de données
RUN apt-get update && apt-get install -y default-mysql-client

# Installer le client MariaDB pour les opérations sur la base de données
RUN apt-get install -y mariadb-client

# Télécharger WordPress et le placer dans le répertoire /var/www/html
RUN wget https://wordpress.org/wordpress-6.1.1.tar.gz -P /var/www/html

RUN cd /var/www/html && \
    tar -xzf /var/www/html/wordpress-6.1.1.tar.gz && \
    rm /var/www/html/wordpress-6.1.1.tar.gz

RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*

EXPOSE 9000

COPY ./tools/auto_config.sh .

RUN chmod +x ./auto_config.sh

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

ENTRYPOINT ["./auto_config.sh"]