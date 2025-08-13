ARG PHP_VERSION

FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine

ARG USER_ID
ARG GROUP_ID
ARG PHP_EXTENSIONS

COPY --chmod=0755 \
    permissions.sh \
    php/cmd.sh \
    php/healthcheck.sh \
    /usr/local/bin/

ADD --chmod=0755 \
    https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    /usr/local/bin/

RUN apk update && apk add --no-cache fcgi


RUN if [ -n "${PHP_EXTENSIONS}" ]; then \
        install-php-extensions ${PHP_EXTENSIONS}; \
    fi

RUN permissions.sh www-data

CMD ["cmd.sh"]