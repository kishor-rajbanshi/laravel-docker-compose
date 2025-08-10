#!/bin/sh

set -e

cmd_log() {
    if [ -z "${PHP_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ "${APP_ENV}" = "production" ]; then
    cmd_log "$0: info: Using production PHP configuration."
    ln -sf "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
else
    cmd_log "$0: info: Using development PHP configuration."
    ln -sf "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
fi

if [ -f /var/www/html/php.ini ]; then
    cmd_log "$0: info: Using php.ini from $(pwd)."
    ln -sf /var/www/html/php.ini "$PHP_INI_DIR/conf.d/php.ini"
fi

docker-php-entrypoint php-fpm
