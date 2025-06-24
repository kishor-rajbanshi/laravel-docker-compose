#!/bin/sh

set -e

if [ "${APP_ENV}" = "production" ]; then
    cp -f "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini";
else 
    cp -f  "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini";
fi

[ -f "/var/www/html/php.ini" ] && cat /var/www/html/php.ini >> "$PHP_INI_DIR/php.ini"

docker-php-entrypoint php-fpm
