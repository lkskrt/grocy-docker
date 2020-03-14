FROM php:7.4.3-fpm-alpine3.11 as grocy-php

ARG GROCY_VERSION

WORKDIR /www

# Install dependencies
RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd && \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install grocy
RUN curl -L \
      "https://github.com/grocy/grocy/releases/download/v${GROCY_VERSION}/grocy_${GROCY_VERSION}.zip" \
      -o /tmp/grocy.zip && \
    unzip /tmp/grocy.zip && \
    rm /tmp/grocy.zip && \
    cp config-dist.php data/config.php

########################################################################################################################

FROM nginx:1.17.9-alpine AS grocy-nginx

WORKDIR /www

COPY nginx.conf /etc/nginx/conf.d/default.conf.template
COPY nginx-entrypoint.sh /usr/local/bin/entrypoint.sh
CMD /usr/local/bin/entrypoint.sh

# Fix permission issues for running as non-root user
RUN chown -R 2000 /etc/nginx/conf.d/ && \
    touch /var/run/nginx.pid && \
    chown -R 2000 /var/run/nginx.pid && \
    chown -R 2000 /var/cache/nginx

COPY --from=grocy-php /www /www

USER 2000:2000
