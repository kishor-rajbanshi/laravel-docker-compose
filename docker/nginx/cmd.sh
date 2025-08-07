#!/bin/sh

set -e

cmd_log() {
    if [ -z "${NGINX_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

i=1; for host in $NGINX_HOSTS; do export HOST_$i="$host"; i=$((i + 1)); done

i=1; for port in $NGINX_PORTS; do export PORT_$i="$port"; i=$((i + 1)); done

i=1; for ssl_port in $NGINX_SSL_PORTS; do export SSL_PORT_$i="$ssl_port"; i=$((i + 1)); done

mkdir -p /etc/nginx/templates

if [ -f /var/www/html/nginx.conf ]; then
    cmd_log "$0: Using nginx.conf from $(pwd)."
    ln -sf /var/www/html/nginx.conf /etc/nginx/templates/default.conf.template
else
    cmd_log "$0: No nginx.conf found in $(pwd) — using default configuration."
    ln -sf /etc/nginx/default.conf.template /etc/nginx/templates/default.conf.template
fi

if [ "${APP_DEBUG}" = "true" ] && command -v nginx-debug >/dev/null; then
    cmd_log "$0: Debug mode enabled, using nginx-debug."
    /docker-entrypoint.sh nginx-debug -g 'daemon off;'
else
    /docker-entrypoint.sh nginx -g 'daemon off;'
fi
