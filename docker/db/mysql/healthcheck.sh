#!/bin/sh

set -e

if [ "$DB_USERNAME" = "root" ]; then
    mysql -h 127.0.0.1 -u root -p"$DB_PASSWORD" -e "SELECT 1;" > /dev/null 2>&1 || exit 1
else
    mysql -h 127.0.0.1 -u "$DB_USERNAME" -p"$DB_PASSWORD" -e "SELECT 1;" > /dev/null 2>&1 || exit 1
fi
