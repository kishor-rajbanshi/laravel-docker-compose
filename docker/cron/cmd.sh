#!/bin/sh

set -e

cmd_log() {
    if [ -z "${CRON_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ "$CRON_ENABLED" != "true" ]; then
    curl -s -X DELETE --unix-socket /var/run/docker.sock "http://localhost/containers/$(hostname)?force=true"
fi

if [ -f /var/www/html/crontab ]; then
    cmd_log "$0: info: Using crontab from $(pwd)."
    ln -sf /var/www/html/crontab /etc/crontabs/www-data
else
    cmd_log "$0: info: Using default crontab."
    ln -sf /etc/crontabs/crontab /etc/crontabs/www-data
fi

exec crond -f -d 8 -l 8
