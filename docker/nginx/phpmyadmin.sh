#!/bin/sh

set -e

me=$(basename "$0")

cmd_log() {
    if [ -z "${NGINX_CMD_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ "$PHPMYADMIN_ENABLED" = "true" ] && { [ "$DB_CONNECTION" = "mysql" ] || [ "$DB_CONNECTION" = "mariadb" ]; }; then
    cmd_log "$me: info: Setting up phpmyadmin"

    sed -i '/@phpmyadmin/{
        c\
    location /phpmyadmin {\
        root /var/www;\
        index index.php;\
    \
        location ~ ^/phpmyadmin/(.+\.php)$ {\
            include fastcgi_params;\
            fastcgi_pass phpmyadmin:9000;\
            fastcgi_param SCRIPT_FILENAME /var/www/html/$1;\
            fastcgi_param PATH_INFO /$1;\
        }\
    \
        location ~* \\\.(js|css|png|jpg|jpeg|gif|ico|svg)$ {\
            expires max;\
            log_not_found off;\
        }\
    }
    }' /etc/nginx/conf.d/*.conf
else
    cmd_log "$me: info: Skipping phpmyadmin - not enabled or unsupported database"

    sed -i '/@phpmyadmin/d' /etc/nginx/conf.d/*.conf
fi
