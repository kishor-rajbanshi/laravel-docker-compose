#!/bin/sh

set -e

if [ -f /var/www/html/nginx.conf ]; then
    ln -sf /var/www/html/nginx.conf /etc/nginx/templates/default.conf.template
else
    ln -sf /etc/nginx/templates/default.conf /etc/nginx/templates/default.conf.template
fi

if [ "${APP_ENV}" = "local" ] && command -v nginx-debug >/dev/null; then
    /docker-entrypoint.sh nginx-debug -g 'daemon off;'
else
    /docker-entrypoint.sh nginx -g 'daemon off;'
fi
