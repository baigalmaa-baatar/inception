FROM alpine:3.15

RUN apk upgrade
RUN apk add php7 php7-fpm php7-opcache php-phar php-json php-iconv
RUN apk add php7-gd php7-mysqli php7-zlib php7-curl bash curl

#Wordpress
ENV WORDPRESS_VERSION 6.0.2
RUN mkdir -p /usr/src
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
	&& rm wordpress.tar.gz \
	&& mkdir -p /var/www/html \
	&& cp -r /usr/src/wordpress/* /var/www/html/.
	
# RUN cd /var/www/html/ && wget http://wordpress.org/latest.tar.gz && tar -xzf latest.tar.gz && rm latest.tar.gz && cp -r wordpress/* . && rm -rf wordpress
# RUN tar -xzvf latest.tar.gz
# RUN rm latest.tar.gz

#Make reachable outside the container
RUN sed -i 's/listen = 127.0.0.1/listen = 0.0.0.0/g' /etc/php7/php-fpm.d/www.conf

# # Install packages
# RUN apk --no-cache add \
#   php8 \
#   php8-fpm \
#   php8-mysqli \
#   php8-json \
#   php8-openssl \
#   php8-curl \
#   php8-zlib \
#   php8-xml \
#   php8-phar \
#   php8-intl \
#   php8-dom \
#   php8-xmlreader \
#   php8-xmlwriter \
#   php8-exif \
#   php8-fileinfo \
#   php8-sodium \
#   php8-gd \
#   php8-simplexml \
#   php8-ctype \
#   php8-mbstring \
#   php8-zip \
#   php8-opcache \
#   php8-iconv \
#   php8-pecl-imagick \
#   supervisor \
#   curl \
#   bash \
#   less

# # Configure PHP-FPM
# COPY config/fpm-pool.conf /etc/php8/php-fpm.d/zzz_custom.conf
# COPY config/php.ini /etc/php8/conf.d/zzz_custom.ini

# # # Configure supervisord
# COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# # wp-content volume
# VOLUME /var/www/wp-content
# WORKDIR /var/www/wp-content
# RUN chown -R nobody.nobody /var/www

# # WordPress
# ENV WORDPRESS_VERSION 6.0.2
# ENV WORDPRESS_SHA1 9348f0757c21504d085a6c866ccbb86573b39d6f

# RUN mkdir -p /usr/src

# # Upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
# RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
# 	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
# 	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
# 	&& rm wordpress.tar.gz \    
# 	&& chown -R nobody.nobody /usr/src/wordpress

# # Add WP CLI
# RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
#     && chmod +x /usr/local/bin/wp

# # WP config
# COPY wp-config.php /usr/src/wordpress
# RUN chown nobody.nobody /usr/src/wordpress/wp-config.php && chmod 640 /usr/src/wordpress/wp-config.php

# # Append WP secrets
# COPY wp-secrets.php /usr/src/wordpress
# RUN chown nobody.nobody /usr/src/wordpress/wp-secrets.php && chmod 640 /usr/src/wordpress/wp-secrets.php


# #rest of the wp configuration
# # wp-client confirguration:
RUN apk add --no-cache curl
RUN apk add --no-cache make
RUN apk add --no-cache mysql-client

# # Install WP-CLI in the toolbox
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# # Entrypoint to copy wp-content
COPY ./tools/wp_entrypoint.sh /usr/local/bin/.
RUN chmod 755 /usr/local/bin/wp_entrypoint.sh

# EXPOSE 9000

# # wp-content volume
VOLUME /var/www/html
WORKDIR /var/www/html
RUN chmod 777 /var/www


CMD ["wp_entrypoint.sh"]

# # HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/wp-login.php