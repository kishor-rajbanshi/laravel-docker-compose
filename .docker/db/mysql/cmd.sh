#!/bin/sh

set -e

user_conf="/var/www/html/my.cnf"
data_dir="/var/db/mysql/"
conf_dir="/etc/mysql/"

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

mkdir -p "$data_dir"

sed -i "s|^datadir=.*|datadir=$data_dir|" "$MYSQL_MAIN_CONF"

if [ -f "$user_conf" ]; then
    cmd_log "$0: info: Using $user_conf"
    ln -sf "$user_conf" "$conf_dir"
fi

docker-entrypoint.sh mysqld
