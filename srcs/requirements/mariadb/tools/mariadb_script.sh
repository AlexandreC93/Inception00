#!/bin/bash

# Démarrer MariaDB
echo "Starting MariaDB service..."
service mariadb start

# Attendre que MariaDB soit prêt
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h localhost --silent; do
  echo "MariaDB is initializing..."
  sleep 2
done
echo "MariaDB is ready!"

# Créer la base de données et configurer l'utilisateur
echo "Creating database and user..."
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -uroot -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

# Définir le mot de passe root
echo "Setting root password..."
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Rafraîchir les privilèges
echo "Flushing privileges..."
mysql -uroot -p${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Arrêter proprement MariaDB
echo "Stopping MariaDB service..."
mysqladmin -uroot -p${SQL_ROOT_PASSWORD} shutdown

# Lancer MariaDB en mode sécurisé
echo "Starting MariaDB in safe mode..."
exec mysqld_safe
