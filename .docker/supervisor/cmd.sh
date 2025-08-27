#!/bin/sh

set -e

main_conf="/etc/supervisord.conf"
default_ini="/etc/supervisor.d/default.ini"
user_ini_template="/var/www/html/supervisor.ini"
user_ini="/etc/supervisor.d/supervisor.ini"

cmd_log() {
    if [ -z "${SUPERVISOR_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ "$QUEUE_CONNECTION" = "sync" ]; then
    curl -s -X DELETE --unix-socket /var/run/docker.sock "http://localhost/containers/$(hostname)?force=true"
fi

cmd_log "$0: info: Running envsubst on $SUPERVISOR_DEFAULT_INI_TEMPLATE to $default_ini"
envsubst < "$SUPERVISOR_DEFAULT_INI_TEMPLATE" > "$default_ini"

if [ -f "$user_ini_template" ]; then
    cmd_log "$0: info: Using $user_ini_template"
    cmd_log "$0: info: Running envsubst on $user_ini_template to $user_ini"
    envsubst < "$user_ini_template" > "$user_ini"
fi

exec supervisord -c "$main_conf"
