#!/bin/bash
# Démarrer le service MariaDB
echo "test"
service mariadb start;

# Créer la base de données si elle n'existe pas
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
