#!/bin/sh

set -e

template_name=default.conf.template
templates_dir=/etc/nginx/templates
nginx_user_conf_template=/var/www/html/nginx.conf

cmd_log() {
    if [ -z "${NGINX_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

i=1; for host in $NGINX_HOSTS; do export HOST_$i="$host"; i=$((i + 1)); done

i=1; for port in $NGINX_PORTS; do export PORT_$i="$port"; i=$((i + 1)); done

i=1; for ssl_port in $NGINX_SSL_PORTS; do export SSL_PORT_$i="$ssl_port"; i=$((i + 1)); done

mkdir -p $templates_dir

if [ -f $nginx_user_conf_template ]; then
    cmd_log "$0: Using $nginx_user_conf_template"
    ln -sf $nginx_user_conf_template $templates_dir/$template_name
else
    cmd_log "$0: No $nginx_user_conf_template found — using default configuration"
    ln -sf $NGINX_DEFAULT_CONF_TEMPLATE $templates_dir/$template_name
fi

if [ "${APP_DEBUG}" = "true" ] && command -v nginx-debug >/dev/null; then
    cmd_log "$0: Debug mode enabled, using nginx-debug"
    /docker-entrypoint.sh nginx-debug -g 'daemon off;'
else
    /docker-entrypoint.sh nginx -g 'daemon off;'
fi
