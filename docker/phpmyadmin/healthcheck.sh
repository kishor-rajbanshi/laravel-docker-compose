#!/bin/sh

set -e

if [ "$PHP_MY_ADMIN" = "true" ] && { [ "$DB_CONNECTION" = "mysql" ] || [ "$DB_CONNECTION" = "mariadb" ]; }; then
    sock="/run/php/php-fpm.sock"
    [ -S "$sock" ] && [ -e /proc/1 ] && exit 0
    exit 1
else
    exit 0
fi
