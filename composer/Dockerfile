ARG IMAGE

FROM ${IMAGE:-php:fpm-alpine}

COPY ./composer/configure.sh /tmp/configure.sh
COPY ./composer/entrypoint.sh /tmp/entrypoint.sh

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN /tmp/configure.sh

USER www-data

ENTRYPOINT ["/tmp/entrypoint.sh"]