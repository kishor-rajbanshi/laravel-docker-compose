FROM phpmyadmin:fpm-alpine

ARG USER_ID
ARG GROUP_ID

COPY permissions.sh /usr/local/bin/

RUN apk update && apk add --no-cache fcgi

RUN permissions.sh www-data

CMD [ "cmd.sh" ]