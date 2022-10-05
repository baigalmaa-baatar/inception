#!/usr/bin/env bash

while ! nc -z mariadb 3306 ; do sleep 1 ; done

cd /var/www/html/

wp config create --allow-root --dbname="$MYSQL_DATABASE" --dbuser="$WP_DB_ADMIN" --dbpass="$MYSQL_ROOT_PASSWORD" --dbhost="$WP_DB_HOST" || true

wp core install --allow-root --url="$WP_URL" --title="$WP_TITLE" --admin_user="$WP_DB_ADMIN" --admin_email="$WP_ADM_MAIL" || true

wp user create "$WP_ADMIN" "$WP_ADMIN_MAIL" --role=administrator --user_pass="$WP_ADMIN_PASS" --allow-root || true

wp user create "$WP_USER" "$WP_USER_MAIL" --role=author --user_pass="$WP_USER_PASS" --allow-root || true

exec php-fpm7 -F $@