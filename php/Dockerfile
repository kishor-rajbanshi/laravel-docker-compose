ARG PHP_VERSION

FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine

ARG UID
ARG GID
ARG ENV
ARG PHP_EXTENSIONS

COPY ./php/cmd.sh /tmp/cmd.sh
COPY ./php/configure.sh /tmp/configure.sh
COPY ./conf.d/php.ini "$PHP_INI_DIR/conf.d/php.ini"
COPY ./scripts /tmp

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN if [ ! -z "${PHP_EXTENSIONS}" ]; then \
        install-php-extensions ${PHP_EXTENSIONS}; \
    fi

RUN mv "$PHP_INI_DIR/php.ini-${ENV:-production}" "$PHP_INI_DIR/php.ini"

RUN /tmp/install-shadow.sh
RUN /tmp/user-group-mod.sh www-data
RUN /tmp/configure.sh

CMD ["/tmp/cmd.sh"]
