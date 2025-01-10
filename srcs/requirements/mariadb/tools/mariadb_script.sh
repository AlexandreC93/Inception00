#!/bin/bash

echo "Starting MariaDB service..."
service mariadb start

echo "Waiting for MariaDB to be fully ready..."
until mysqladmin ping > /dev/null 2>&1; do
  echo "MariaDB is initializing..."
  sleep 2
done
echo "MariaDB is fully ready."

# Redéfinir le mot de passe root
echo "Setting root password..."
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

echo "Testing root connection with password..."
if mysql -uroot -p${SQL_ROOT_PASSWORD} -e "SELECT 1;" > /dev/null 2>&1; then
  echo "Root connection successful."
else
  echo "Error: Unable to connect to MariaDB with root user."
  tail -n 50 /var/log/mysql/error.log
  exit 1
fi

# Créer la base de données
echo "Creating database '${SQL_DATABASE}'..."
mysql -uroot -p${SQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Créer l'utilisateur
echo "Creating user '${SQL_USER}'..."
mysql -uroot -p${SQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Accorder les privilèges
echo "Granting privileges to user '${SQL_USER}' on database '${SQL_DATABASE}'..."
mysql -uroot -p${SQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

# Rafraîchir les privilèges
echo "Flushing privileges..."
mysql -uroot -p${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Fermer MariaDB
echo "Shutting down MariaDB..."
mysqladmin -uroot -p${SQL_ROOT_PASSWORD} shutdown

# Démarrer MariaDB en mode sécurisé
echo "Starting MariaDB in safe mode..."
exec mysqld_safe
