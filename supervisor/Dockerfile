ARG IMAGE

FROM ${IMAGE:-php:fpm-alpine}

COPY ./supervisor/cmd.sh /tmp/cmd.sh
COPY ./build.d/supervisor.sh /tmp/configure.sh
COPY ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./conf.d/supervisor.conf /etc/supervisor/supervisor.conf

RUN apk update && apk add --no-cache supervisor

RUN /tmp/configure.sh

CMD ["/tmp/cmd.sh"]