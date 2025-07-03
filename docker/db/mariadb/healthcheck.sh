#!/bin/sh

set -e

mariadb -h 127.0.0.1 -u "$DB_USERNAME" -p"$DB_PASSWORD" -e "SELECT 1;" > /dev/null 2>&1 || exit 1
