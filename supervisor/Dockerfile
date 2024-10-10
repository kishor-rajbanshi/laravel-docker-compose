ARG IMAGE

FROM ${IMAGE:-php:fpm-alpine}

COPY ./supervisor/cmd.sh /tmp/cmd.sh
COPY ./supervisor/configure.sh /tmp/configure.sh
COPY ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./conf.d/supervisor.conf /etc/supervisor/supervisor.conf
COPY ./scripts /tmp

RUN apk update && apk add --no-cache supervisor

RUN /tmp/configure.sh

CMD ["/tmp/cmd.sh"]