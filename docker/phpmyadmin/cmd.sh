#!/bin/sh

set -e

if [ "$PHP_MY_ADMIN" = "true" ] && { [ "$DB_CONNECTION" = "mysql" ] || [ "$DB_CONNECTION" = "mariadb" ]; }; then
    /docker-entrypoint.sh php-fpm
else
    while [ "$(docker inspect -f '{{.State.Health.Status}}' ${APP_NAME}-nginx 2>/dev/null)" != "healthy" ]; do
        sleep 1
    done

    docker rm -f "$(hostname)"
fi
