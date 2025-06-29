#!/bin/sh

set -e

if [ "$PHP_MY_ADMIN" = "true" ] && { [ "$PMA_HOST" = "mysql" ] || [ "$PMA_HOST" = "mariadb" ]; }; then
    php-fpm -t 2>&1 | grep -q 'test is successful' && exit 0 || exit 1
else
    exit 0
fi
