#!/bin/bash
set -e

echo "---- Initialisation de la base de donnees MariaDB ----"

# Lancer temporairement MySQL sans acces reseau
echo "Demarrage temporaire de MariaDB pour configuration..."
mysqld_safe --skip-networking &
sleep 5

until mysqladmin ping --silent -u root; do
    echo "Attente du demarrage de MySQL..."
    sleep 1
done

# Creation initiale
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
	echo "Initialisation de la base MySQL..."
	mysql -u root <<-EOSQL
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		FLUSH PRIVILEGES;
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		FLUSH PRIVILEGES;
	EOSQL
else
	echo "Base deja initialisee."
fi

# Arret du MariaDB temporaire
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

echo "Base de donnees prete, lancement de mysqld..."
exec mysqld_safe
