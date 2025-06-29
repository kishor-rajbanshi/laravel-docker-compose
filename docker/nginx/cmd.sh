#!/bin/sh

set -e

if [ -f /var/www/html/nginx.conf ]; then
    ln -sf /var/www/html/nginx.conf /etc/nginx/templates/default.conf.template
else
    ln -sf /etc/nginx/templates/default.conf /etc/nginx/templates/default.conf.template
fi

if [ "$PHP_MY_ADMIN" = "true" ]; then
cat << 'EOF' >> /etc/nginx/conf.d/default.conf

location /phpmyadmin {
    root /var/www;
    index index.php;

    location ~ ^/phpmyadmin/(.+\.php)$ {
        include fastcgi_params;
        fastcgi_pass phpmyadmin:9000;
        fastcgi_param SCRIPT_FILENAME /var/www/html/$1;
        fastcgi_param PATH_INFO /$1;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires max;
        log_not_found off;
    }
}
EOF
fi

if [ "${APP_DEBUG}" = "true" ] && command -v nginx-debug >/dev/null; then
    /docker-entrypoint.sh nginx-debug -g 'daemon off;'
else
    /docker-entrypoint.sh nginx -g 'daemon off;'
fi
