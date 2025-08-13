#!/bin/sh

set -e

cmd_log() {
    if [ -z "${DB_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

export MYSQL_DATABASE=${DB_DATABASE}

if [ "$DB_USERNAME" = "root" ]; then
    export MYSQL_ROOT_PASSWORD=${DB_PASSWORD}
else
    export MYSQL_RANDOM_ROOT_PASSWORD=true
    export MYSQL_USER=${DB_USERNAME}
    export MYSQL_PASSWORD=${DB_PASSWORD}
fi

mkdir -p /var/db/mysql

sed -i 's|^datadir=.*|datadir=/var/db/mysql|' /etc/my.cnf

if [ -f /var/www/html/my.cnf ]; then
    cmd_log "$0: info: Using my.cnf from $(pwd)."
    ln -sf /var/www/html/my.cnf /etc/mysql/my.cnf
fi

docker-entrypoint.sh mysqld
