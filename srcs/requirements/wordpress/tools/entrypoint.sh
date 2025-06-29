#!/bin/bash

set -e

# Attente que MariaDB soit prete
echo "Attente de MariaDB ($MYSQL_HOST)..."
until mysqladmin ping -h"$MYSQL_HOST" --silent; do
	sleep 1
done
echo "MariaDB prete !"

# Telechargement de WordPress si pas deja present
if [ ! -f /var/www/html/wp-load.php ]; then
	echo "Telechargement de WordPress..."
	wget https://wordpress.org/latest.tar.gz
	tar -xzf latest.tar.gz
	mv wordpress/* /var/www/html/
	rm -rf latest.tar.gz wordpress
	echo "WordPress telecharge !"
fi

cd /var/www/html

# Creation automatique du wp-config.php
if [ ! -f wp-config.php ]; then
	echo "Creation de wp-config.php..."
	wp config create \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="$MYSQL_HOST" \
		--path='/var/www/html' \
		--allow-root
	echo "wp-config.php cree !"
fi

# Installation de WordPress si non deja installee
if ! wp core is-installed --allow-root; then
	echo "Installation de WordPress..."
	wp core install \
		--url="$DOMAIN_NAME" \
		--title="inception_42" \
		--admin_user="$WP_ADMIN" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--allow-root
	echo "WordPress installe !"
else
	echo "WordPress deja installe"
fi

# Creation d’un second utilisateur si pas deja existant
if ! wp user get "$WP_USER" --allow-root > /dev/null 2>&1; then
	echo "Creation du second user ($WP_USER)..."
	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--user_pass="$WP_USER_PASSWORD" \
		--role=subscriber \
		--allow-root
	echo "Utilisateur secondaire cree !"
fi

echo "Lancement de PHP-FPM..."
exec php-fpm -F