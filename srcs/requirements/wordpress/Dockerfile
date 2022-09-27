FROM wordpress:6.0.2-fpm-alpine

RUN apk add --no-cache curl
RUN apk add --no-cache make
RUN apk add --no-cache mysql-client

# Install WP-CLI in the toolbox
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Install MySQL extension, as WP-CLI needs to access to WordPress database
# RUN docker-php-ext-install mysqli

COPY ./tools/entrypoint.sh /usr/local/bin/.
RUN chmod 755 /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]