#!/bin/sh

set -e

if [ -f /var/www/html/supervisord.conf ]; then
    CONF_FILE=/var/www/html/supervisord.conf
else
    CONF_FILE=/etc/supervisor.d/default.conf
fi

if [ "$QUEUE_CONNECTION" = "sync" ]; then
    docker rm -f "$(hostname)"
fi

envsubst < "$CONF_FILE" > /etc/supervisord.conf

exec supervisord -c /etc/supervisord.conf
