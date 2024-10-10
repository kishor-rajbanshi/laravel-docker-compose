#!/bin/sh

set -e

if [ ! -z "$NGINX_SERVER_NAME" ]; then
    sed -i "/server_name/c\server_name ${NGINX_SERVER_NAME};" /etc/nginx/conf.d/default.conf
fi
