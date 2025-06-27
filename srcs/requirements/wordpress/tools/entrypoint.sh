#!/bin/bash

set -e

# ➤ Attente que MariaDB soit prets
echo "Attente de MariaDB ($MYSQL_HOST)..."
until mysqladmin --silent ping -h "$MYSQL_HOST" --silent; do
    sleep 1
done
echo "MariaDB est pret !"

# ➤ Telechargement de WordPress si pas encore prsent
if [ ! -f /var/www/html/wp-load.php ]; then
    echo "  Telechargement de WordPress..."
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    mv wordpress/* /var/www/html/
    rm -rf latest.tar.gz wordpress
    echo "WordPress telecharge"
fi

cd /var/www/html

# ➤ Génération automatique du wp-config.php
if [ ! -f wp-config.php ]; then
    echo "Creation de wp-config.php..."
    wp config create \
        --dbname="$MYSQL_DATABASE" \
	--dbuser="$MYSQL_USER" \
	--dbpass="$MYSQL_PASSWORD" \
	--dbhost="$MYSQL_HOST" \
	--path='/var/www/html' \
	--allow-root
   echo "wp-config.php pret !"
fi

if ! wp core is-installed --allow-root; then
	echo "installation de wordpress..."
	wp core install \
		--url="$DOMAIN_NAME" \
		--title="inception42" \
		--admin_user="$WP_ADMIN" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--allow-root
	echo "WordPress installer !"
else
	echo "WordPress est deja installer"
fi

echo "Lancement de PHP-FPM"
exec php-fpm -F

