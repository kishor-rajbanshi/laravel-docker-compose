ARG IMAGE

FROM ${IMAGE:-php:fpm-alpine}

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

USER www-data

ENTRYPOINT [ "entrypoint.sh" ]