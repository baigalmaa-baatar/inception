#!/usr/bin/env bash
set -m

/usr/local/bin//docker-entrypoint.sh php-fpm &

while ! nc -z mariadb 3306 ; do sleep 1 ; done

wp config create --allow-root --dbname=wpdb --dbuser=root --dbpass=aqwe123 --dbhost=mariadb || true

wp core install --allow-root --url=localhost --title=inception --admin_user=root --admin_email=inception@gmail.com || true

wp user create bbaatar bbaatar@example.com --role=administrator --user_pass=pass1 --allow-root || true

wp user create bob1 bob1@example.com --role=author --user_pass=pass --allow-root || true

fg