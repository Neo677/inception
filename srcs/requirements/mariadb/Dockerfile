#------------------------------------------------------------------------------------
#			MariaDB dockerfile		
#------------------------------------------------------------------------------------

FROM debian:bullseye

RUN apt update && apt install -y mariadb-server

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Autoriser les connexions depuis n'importe où
RUN sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

EXPOSE 3306
CMD ["/entrypoint.sh"]
