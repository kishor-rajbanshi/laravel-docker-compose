#!/bin/sh

set -e

if [ "${APP_ENV}" = "production" ]; then
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini";
else 
    mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini";
fi

docker-php-entrypoint php-fpm
