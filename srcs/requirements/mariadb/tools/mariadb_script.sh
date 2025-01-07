#!/bin/bash
# Démarrer le service MariaDB
service mariadb start;

echo ${SQL_ROOT_PASSWORD}
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
# Créer la base de données si elle n'existe pas
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Créer l'utilisateur s'il n'existe pas
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
# Accorder tous les privilèges à l'utilisateur sur la base de données
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Changer le mot de passe du root

# Reactualisation des privilèges
mysql -e "FLUSH PRIVILEGES;"

# Arrêter proprement MariaDB
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

# Lancer MariaDB en mode sécurisé
exec mysqld_safe

# Message de succès
echo "MariaDB database and user were created successfully!"