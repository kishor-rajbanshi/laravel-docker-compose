FROM phpmyadmin:fpm-alpine

ARG USER_ID
ARG GROUP_ID

COPY permissions.sh /usr/local/bin/

RUN apk update && apk add --no-cache docker-cli fcgi

RUN permissions.sh www-data

CMD [ "cmd.sh" ]