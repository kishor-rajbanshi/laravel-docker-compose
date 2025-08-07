#!/bin/sh

set -e

if [ "$QUEUE_CONNECTION" = "sync" ]; then
    curl -s -X DELETE --unix-socket /var/run/docker.sock "http://localhost/containers/$(hostname)?force=true"
fi

export DEFAULT_PROGRAM_NAME="${COMPOSE_PROJECT_NAME}-worker"

envsubst < /etc/supervisor.d/templates/default.ini.template > /etc/supervisor.d/default.ini

if [ -f /var/www/html/supervisor.ini ]; then
    envsubst < /var/www/html/supervisor.ini > /etc/supervisor.d/supervisor.ini
fi

exec supervisord -c /etc/supervisord.conf
