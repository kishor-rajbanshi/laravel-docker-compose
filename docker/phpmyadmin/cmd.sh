#!/bin/sh

set -e

if [ "$PHP_MY_ADMIN" = "true" ] && { [ "$PMA_HOST" = "mysql" ] || [ "$PMA_HOST" = "mariadb" ]; }; then
    /docker-entrypoint.sh php-fpm
else
    apk add --no-cache docker-cli

    while [ "$(docker inspect -f '{{.State.Health.Status}}' ${APP_NAME}-nginx 2>/dev/null)" != "healthy" ]; do
        sleep 1
    done

    docker rm -f "$(hostname)"
fi
