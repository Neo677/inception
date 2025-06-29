#------------------------------------------------------------------------------
#       WordPress Dockerfile - PHP-FPM
#------------------------------------------------------------------------------

FROM php:7.4-fpm

# Paquets necessaires
RUN apt-get update && apt-get install -y \
	mariadb-client \
	wget \
	unzip \
	less \
	curl \
	libpng-dev \
	libonig-dev \
	libxml2-dev \
	zip \
	&& docker-php-ext-install pdo_mysql mysqli

# Installation de WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copie de l’entree
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html
ENTRYPOINT ["/entrypoint.sh"]
