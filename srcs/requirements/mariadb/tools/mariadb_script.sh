#!/bin/bash
# Démarrer le service MariaDB
echo "test"

service mariadb start;
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -hlocalhost --silent; do
  echo "MariaDB is not ready. Retrying..."
  sleep 2
done
echo "MariaDB is ready!"

# Changer le mot de passe du root
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Créer la base de données si elle n'existe pas
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Créer l'utilisateur s'il n'existe pas
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"

# Accorder tous les privilèges à l'utilisateur sur la base de données
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Reactualisation des privilèges
mysql -e "FLUSH PRIVILEGES;"

# Arrêter proprement MariaDB
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

# Lancer MariaDB en mode sécurisé
exec mysqld_safe

# Message de succès
echo "MariaDB database and user were created successfully!"