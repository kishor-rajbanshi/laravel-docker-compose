#!/bin/sh

set -e

if [ -f /var/www/html/cronjobs ]; then
    ln -sf /var/www/html/cronjobs /etc/crontabs/www-data
else
    ln -sf /tmp/jobs /etc/crontabs/www-data
fi

if [ "$CRON_ENABLED" != "true" ]; then
    docker rm -f "$(hostname)"
fi

exec crond -f -d 8 -l 8
