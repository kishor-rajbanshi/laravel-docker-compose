ARG IMAGE

FROM ${IMAGE:-php:fpm-alpine}

COPY ./cron/cmd.sh /tmp/cmd.sh
COPY ./cron/configure.sh /tmp/configure.sh
COPY ./conf.d/cronjobs /etc/crontabs/www-data
COPY ./scripts /tmp

RUN apk update && apk add --no-cache tini dcron

RUN /tmp/configure.sh

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/tmp/cmd.sh"]