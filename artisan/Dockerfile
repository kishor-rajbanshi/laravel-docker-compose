ARG IMAGE

FROM ${IMAGE:-php:fpm-alpine}

COPY ./build.d/artisan.sh /tmp/configure.sh
COPY ./artisan/entrypoint.sh /tmp/entrypoint.sh

RUN /tmp/configure.sh

USER www-data

ENTRYPOINT ["/tmp/entrypoint.sh"]