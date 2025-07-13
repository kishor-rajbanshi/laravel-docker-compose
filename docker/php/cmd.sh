#!/bin/sh

set -e

if [ "${APP_ENV}" = "production" ]; then
    ln -sf "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
else
    ln -sf "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
fi

if [ -f /var/www/html/php.ini ]; then
    ln -sf /var/www/html/php.ini "$PHP_INI_DIR/conf.d/php.ini"
fi

docker-php-entrypoint php-fpm
