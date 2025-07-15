FROM phpmyadmin:fpm-alpine

ARG USER_ID
ARG GROUP_ID

COPY permissions.sh /usr/local/bin/

RUN apk update && apk add --no-cache fcgi jq

RUN permissions.sh www-data

CMD [ "cmd.sh" ]