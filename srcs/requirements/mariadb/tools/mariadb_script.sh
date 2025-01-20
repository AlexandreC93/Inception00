#!/bin/bash
echo "test";

# Démarrer MariaDB
service mariadb start;

# Attendre que MariaDB soit prêt
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h localhost --silent; do
  echo "MariaDB is initializing..."
  sleep 2
done
echo "MariaDB is ready!"

# Créer la base de données si elle n'existe pas
echo "Creating database '${SQL_DATABASE}'..."
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Créer l'utilisateur s'il n'existe pas
echo "Creating user '${SQL_USER}'..."
mysql -uroot -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"

# Accorder tous les privilèges à l'utilisateur
echo "Granting privileges to user '${SQL_USER}' on database '${SQL_DATABASE}'..."
mysql -uroot -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

# Changer le mot de passe du root
echo "Setting root password..."
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Rafraîchir les privilèges
echo "Flushing privileges..."
mysql -uroot -p${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Arrêter proprement MariaDB
echo "Shutting down MariaDB..."
mysqladmin -uroot -p${SQL_ROOT_PASSWORD} shutdown

# Lancer MariaDB en mode sécurisé
echo "Starting MariaDB in safe mode..."
exec mysqld_safe

# Message de succès
echo "MariaDB database and user were created successfully!"
