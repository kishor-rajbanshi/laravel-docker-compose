#!/bin/sh

set -e

cmd_log() {
    if [ -z "${DB_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

export MARIADB_DATABASE=${DB_DATABASE}

if [ "$DB_USERNAME" = "root" ]; then
    export MARIADB_ROOT_PASSWORD=${DB_PASSWORD}
else
    export MARIADB_RANDOM_ROOT_PASSWORD=true
    export MARIADB_USER=${DB_USERNAME}
    export MARIADB_PASSWORD=${DB_PASSWORD}
fi

mkdir -p /var/db/mariadb

echo "[mariadbd]\ndatadir=/var/db/mariadb" >/etc/mysql/mariadb.conf.d/datadir.cnf

if [ -f /var/www/html/mariadb.cnf ]; then
    cmd_log "$0: info: Using mariadb.cnf from $(pwd)."
    ln -sf /var/www/html/mariadb.cnf /etc/mysql/mariadb.conf.d/
fi

docker-entrypoint.sh mariadbd
