#------------------------------------------------------------------------------------
#			Nginx dockerfile
#------------------------------------------------------------------------------------
    
FROM debian:bullseye

RUN apt update && apt install -y nginx openssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/entrypoint.sh"]

