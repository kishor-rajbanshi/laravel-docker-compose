#!/bin/sh

set -e

user_conf_file="/var/www/html/nginx.conf"
template_file="/etc/nginx/templates/default.conf.template"

cmd_log() {
    if [ -z "${NGINX_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

i=1
for host in "${NGINX_HOSTS}"; do
    export HOST_${i}="$host"
    i=$((i + 1))
done

i=1
for port in "${NGINX_PORTS}"; do
    export PORT_${i}="$port"
    i=$((i + 1))
done

i=1
for ssl_port in "${NGINX_SSL_PORTS}"; do
    export SSL_PORT_${i}="$ssl_port"
    i=$((i + 1))
done

if [ -f "$user_conf_file" ]; then
    cmd_log "${0}: Using $user_conf_file"
    ln -sf "$user_conf_file" "$template_file"
else
    cmd_log "${0}: No $user_conf_file found — using default configuration"
    ln -sf "$NGINX_DEFAULT_CONF_FILE" "$template_file"
fi

if [ "${APP_DEBUG}" = "true" ] && command -v nginx-debug >/dev/null; then
    cmd_log "${0}: Debug mode enabled, using nginx-debug"
    /docker-entrypoint.sh nginx-debug -g 'daemon off;'
else
    /docker-entrypoint.sh nginx -g 'daemon off;'
fi
