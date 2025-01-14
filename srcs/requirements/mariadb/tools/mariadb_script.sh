#!/bin/bash
# Démarrer le service MariaDB
echo "test"
service mariadb start;

# Changer le mot de passe du root
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
