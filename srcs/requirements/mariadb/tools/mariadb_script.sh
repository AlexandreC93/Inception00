#!/bin/bash

# Démarrer le service MariaDB
service mariadb start

# Attendre que MariaDB soit prêt
until mysqladmin ping > /dev/null 2>&1; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

echo "MariaDB is ready."

# Créer la base de données si elle n'existe pas
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Créer l'utilisateur s'il n'existe pas
mysql -uroot -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Accorder tous les privilèges à l'utilisateur sur la base de données
mysql -uroot -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

# Définir le mot de passe pour l'utilisateur root
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Reactualisation des privilèges
mysql -uroot -p${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Arrêter proprement MariaDB
mysqladmin -uroot -p${SQL_ROOT_PASSWORD} shutdown

# Lancer MariaDB en mode sécurisé
exec mysqld_safe

# Message de succès
echo "MariaDB database and user were created successfully!"
