#!/bin/sh

# Genere le certificat si absent
if [ ! -f /etc/ssl/certs/nginx.crt ]; then
	echo "Génération du certificat SSL auto-signé..."
	openssl req -x509 -nodes -days 365 \
		-subj "/C=FR/ST=IDF/L=Nice/O=42/OU=thobenel/CN=${DOMAIN_NAME}" \
		-newkey rsa:2048 \
		-keyout /etc/ssl/private/nginx.key \
		-out /etc/ssl/certs/nginx.crt
fi

# Lancer nginx
echo "Lancement de nginx..."
nginx -g 'daemon off;'
