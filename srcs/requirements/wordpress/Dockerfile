FROM alpine:3.15

# php-fpm

RUN apk upgrade
RUN apk add php7 php7-fpm php7-opcache php-phar php-json php-iconv
RUN apk add php7-gd php7-mysqli php7-zlib php7-curl bash curl

# Wordpress
ENV WORDPRESS_VERSION 6.0.2
RUN mkdir -p /usr/src
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
	&& rm wordpress.tar.gz \
	&& mkdir -p /var/www/html \
	&& cp -r /usr/src/wordpress/* /var/www/html/.
	
# Make reachable outside the container
RUN sed -i 's/listen = 127.0.0.1/listen = 0.0.0.0/g' /etc/php7/php-fpm.d/www.conf

# wp-client confirguration:
RUN apk add --no-cache curl
RUN apk add --no-cache make
RUN apk add --no-cache mysql-client

# Install WP-CLI in the toolbox
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Entrypoint to copy wp-content
COPY ./tools/wp_entrypoint.sh /usr/local/bin/.
RUN chmod 755 /usr/local/bin/wp_entrypoint.sh

# wp-content volume
VOLUME /var/www/html
WORKDIR /var/www/html
RUN chmod 777 /var/www

CMD ["wp_entrypoint.sh"]