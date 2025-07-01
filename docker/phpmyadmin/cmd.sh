#!/bin/sh

set -e

if [ -f /var/www/app/phpmyadmin.config.inc.php ]; then
    mkdir -p /etc/phpmyadmin/conf.d

    ln -sf /var/www/app/phpmyadmin.config.inc.php /etc/phpmyadmin/conf.d/
fi

if [ "$PHP_MY_ADMIN" = "true" ] && { [ "$DB_CONNECTION" = "mysql" ] || [ "$DB_CONNECTION" = "mariadb" ]; }; then
    /docker-entrypoint.sh php-fpm
else
    apk add --no-cache docker-cli

    while [ "$(docker inspect -f '{{.State.Health.Status}}' ${APP_NAME}-nginx 2>/dev/null)" != "healthy" ]; do
        sleep 1
    done

    docker rm -f "$(hostname)"
fi
