#!/bin/bash

# Démarrer le service MariaDB
echo "Starting MariaDB service..."
service mariadb start

# Attendre que MariaDB soit prêt
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping > /dev/null 2>&1; do
  echo "MariaDB is not ready yet. Retrying..."
  sleep 2
done
echo "MariaDB is ready."

# Vérification de la connexion initiale avec root sans mot de passe
echo "Testing initial root connection..."
if ! mysql -uroot -e "SELECT 1;" > /dev/null 2>&1; then
  echo "Error: Unable to connect to MariaDB with root user."
  exit 1
fi
echo "Root connection successful."

# Créer la base de données si elle n'existe pas
echo "Creating database '${SQL_DATABASE}'..."
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Créer l'utilisateur avec accès global
echo "Creating user '${SQL_USER}'..."
mysql -uroot -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Accorder les privilèges
echo "Granting privileges to user '${SQL_USER}' on database '${SQL_DATABASE}'..."
mysql -uroot -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

# Changer le mot de passe root
echo "Updating root password..."
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Rafraîchir les privilèges
echo "Flushing privileges..."
mysql -uroot -p${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Arrêter MariaDB
echo "Shutting down MariaDB..."
mysqladmin -uroot -p${SQL_ROOT_PASSWORD} shutdown

# Démarrer MariaDB en mode sécurisé
echo "Starting MariaDB in safe mode..."
exec mysqld_safe
