FROM alpine:3.15

RUN apk update
RUN	apk add mariadb mariadb-client bash
RUN	mariadb-install-db --datadir=/var/lib/mysql
RUN	mkdir /run/mysqld/

# EXPOSE 3306

# purge and re-create /var/lib/mysql with appropriate ownership

RUN	rm -rf /var/lib/mysql; \
	mkdir -p /var/lib/mysql /var/run/mysqld; \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld; \
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
	chmod 777 /var/run/mysqld;
# comment out a few problematic configuration values

VOLUME ["/var/lib/mysql"]

# allows mysql to connect remotely
RUN echo "skip-networking=0" >> /etc/my.cnf
RUN echo "skip-bind-address" >> /etc/my.cnf

# # Entrypoint
COPY ./tools/mariadb_entrypoint.sh /usr/local/bin/.
RUN chmod 755 /usr/local/bin/mariadb_entrypoint.sh

CMD ["mariadb_entrypoint.sh"]
