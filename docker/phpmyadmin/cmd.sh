#!/bin/sh

set -e

if [ "$PHPMYADMIN_ENABLED" != "true" ] || { [ "$DB_CONNECTION" != "mysql" ] && [ "$DB_CONNECTION" != "mariadb" ]; }; then
    while true; do
        status="$(curl -s --unix-socket /var/run/docker.sock http://localhost/containers/${COMPOSE_PROJECT_NAME}-nginx/json | jq -r '.State.Status' 2>/dev/null)"

        [ "$status" = "running" ] && break

        echo "Waiting for ${COMPOSE_PROJECT_NAME}-nginx to start"
        
        sleep 1
    done
    
    curl -s -X DELETE --unix-socket /var/run/docker.sock "http://localhost/containers/$(hostname)?force=true"
fi

if [ -f /var/www/app/config.inc.php ]; then
    mkdir -p /etc/phpmyadmin/conf.d

    ln -sf /var/www/app/config.inc.php /etc/phpmyadmin/conf.d/
fi

/docker-entrypoint.sh php-fpm
