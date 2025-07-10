#!/bin/sh

set -e

if [ -f /var/www/app/config.inc.php ]; then
    mkdir -p /etc/phpmyadmin/conf.d

    ln -sf /var/www/app/config.inc.php /etc/phpmyadmin/conf.d/
fi

if [ "$PHP_MY_ADMIN_ENABLED" = "true" ] && { [ "$DB_CONNECTION" = "mysql" ] || [ "$DB_CONNECTION" = "mariadb" ]; }; then
    /docker-entrypoint.sh php-fpm
else
    apk update && apk add --no-cache docker-cli

    while [ "$(docker inspect -f '{{.State.Status}}' ${APP_NAME}-nginx 2>/dev/null)" != "running" ]; do
        sleep 1
    done

    docker rm -f "$(hostname)"
fi
