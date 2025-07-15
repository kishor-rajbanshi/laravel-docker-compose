#!/bin/sh

set -e

if [ "$PHPMYADMIN_ENABLED" != "true" ] || { [ "$DB_CONNECTION" != "mysql" ] && [ "$DB_CONNECTION" != "mariadb" ]; }; then
    while [ "$(docker inspect -f '{{.State.Status}}' ${APP_NAME}-nginx 2>/dev/null)" != "running" ]; do
        sleep 1
    done

    docker rm -f "$(hostname)"
fi

if [ -f /var/www/app/config.inc.php ]; then
    mkdir -p /etc/phpmyadmin/conf.d

    ln -sf /var/www/app/config.inc.php /etc/phpmyadmin/conf.d/
fi

/docker-entrypoint.sh php-fpm
