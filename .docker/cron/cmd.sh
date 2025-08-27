#!/bin/sh

set -e

user_crontab="/var/www/html/crontab"

cmd_log() {
    if [ -z "${CRON_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ "$CRON_ENABLED" != "true" ]; then
    curl -s -X DELETE --unix-socket /var/run/docker.sock "http://localhost/containers/$(hostname)?force=true"
fi

if [ -f "$user_crontab" ]; then
    cmd_log "$0: info: Using $user_crontab"
    ln -sf "$user_crontab" "$WWW_DATA_CRONTAB"
else
    cmd_log "$0: info: Using default crontab"
    ln -sf "$DEFAULT_CRONTAB" "$WWW_DATA_CRONTAB"
fi

exec crond -f -d 8 -l 8
