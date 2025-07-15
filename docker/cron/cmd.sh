#!/bin/sh

set -e

if [ "$CRON_ENABLED" != "true" ]; then
    curl -s -X DELETE --unix-socket /var/run/docker.sock "http://localhost/containers/$(hostname)?force=true"
fi

if [ -f /var/www/html/crontab ]; then
    ln -sf /var/www/html/crontab /etc/crontabs/www-data
else
    ln -sf /etc/crontabs/crontab /etc/crontabs/www-data
fi

[ ! -p /tmp/cron-logger.pipe ] && mkfifo /tmp/cron-logger.pipe
tee /var/log/cron.log < /tmp/cron-logger.pipe &

exec crond -f -d 8 -l 8 -L /tmp/cron-logger.pipe
