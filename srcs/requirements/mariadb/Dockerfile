FROM debian:bullseye

RUN apt-get update -y

RUN apt-get upgrade -y

RUN apt-get install -y mariadb-server

RUN apt-get install -y mariadb-client

# Installer l'outil procps pour la gestion des processus
RUN apt-get install -y procps

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Créer le répertoire pour les fichiers PID de MariaDB
RUN mkdir -p /var/run/mysqld

# Créer le répertoire pour les données de MariaDB
RUN mkdir -p /var/lib/mysql

# Attribuer les permissions à l'utilisateur MySQL pour le répertoire PID
RUN chown mysql:mysql /var/run/mysqld/

# Donner des permissions de lecture/écriture/exécution au répertoire PID
RUN chmod -R 755 /var/run/mysqld/

# Attribuer les permissions à l'utilisateur MySQL pour le répertoire des données
RUN chown mysql:mysql /var/lib/mysql/

# Donner des permissions de lecture/écriture/exécution au répertoire des données
RUN chmod -R 755 /var/lib/mysql/

EXPOSE 3306

COPY ./tools/mariadb_script.sh .

RUN chmod +x ./mariadb_script.sh

ENTRYPOINT ["./mariadb_script.sh"]