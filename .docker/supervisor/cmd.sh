#!/bin/sh

set -e

cmd_log() {
    if [ -z "${SUPERVISOR_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ "$QUEUE_CONNECTION" = "sync" ]; then
    curl -s -X DELETE --unix-socket /var/run/docker.sock "http://localhost/containers/$(hostname)?force=true"
fi

export DEFAULT_PROGRAM_NAME="${COMPOSE_PROJECT_NAME}-worker"

cmd_log "$0: info: Running envsubst on /etc/supervisor.d/templates/default.ini.template to /etc/supervisor.d/default.ini"
envsubst < /etc/supervisor.d/templates/default.ini.template > /etc/supervisor.d/default.ini

if [ -f /var/www/html/supervisor.ini ]; then
    cmd_log "$0: info: Using supervisor.ini from $(pwd)."
    cmd_log "$0: info: Running envsubst on /var/www/html/supervisor.ini to /etc/supervisor.d/supervisor.ini"
    envsubst < /var/www/html/supervisor.ini > /etc/supervisor.d/supervisor.ini
fi

exec supervisord -c /etc/supervisord.conf
