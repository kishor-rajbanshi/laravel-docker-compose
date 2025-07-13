#!/bin/sh

set -e

if [ "$PHPMYADMIN_ENABLED" = "true" ] && { [ "$DB_CONNECTION" = "mysql" ] || [ "$DB_CONNECTION" = "mariadb" ]; }; then
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
    sed -i '/@phpmyadmin/d' /etc/nginx/conf.d/*.conf
fi
