FROM debian:bullseye

# Mettre à jour la liste des paquets
RUN apt-get update -y

# Mettre à niveau les paquets installés
RUN apt-get upgrade -y

# Installer le serveur MariaDB
RUN apt-get install -y mariadb-server

# Installer le client MariaDB
RUN apt-get install -y mariadb-client

# Installer l'outil procps pour la gestion des processus
RUN apt-get install -y procps

# Copier le fichier de configuration personnalisé de MariaDB
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

# Exposer le port 3306 pour les connexions MariaDB
EXPOSE 3306

# Copier le script d'initialisation dans l'image
COPY ./tools/mariadb_script.sh .

# Rendre le script d'initialisation exécutable
RUN chmod +x ./mariadb_script.sh

# Définir le point d'entrée pour lancer le script d'initialisation
ENTRYPOINT ["./mariadb_script.sh"]