#!/bin/sh

set -e

user_cnf="/var/www/html/my.cnf"
data_dir="/var/db/mysql"
conf_dir="/etc/mysql/conf.d"

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

echo -e "[mysqld]\ndatadir=$data_dir" >"${conf_dir}/datadir.cnf"

if [ -f "$user_cnf" ]; then
    cmd_log "${0}: info: Using $user_cnf"
    ln -sf "$user_cnf" "$conf_dir"
fi

docker-entrypoint.sh mysqld
