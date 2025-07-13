#!/bin/sh

set -e

i=1
for host in $NGINX_HOSTS; do
    export NGINX_HOST_$i="$host"
    i=$((i + 1))
done

if [ -f /var/www/html/nginx.conf ]; then
    ln -sf /var/www/html/nginx.conf /etc/nginx/templates/nginx.conf.template
else
    mkdir -p /etc/nginx/templates
    ln -sf /etc/nginx/default.conf.template /etc/nginx/templates/default.conf.template
fi

if [ "${APP_DEBUG}" = "true" ] && command -v nginx-debug >/dev/null; then
    /docker-entrypoint.sh nginx-debug -g 'daemon off;'
else
    /docker-entrypoint.sh nginx -g 'daemon off;'
fi
