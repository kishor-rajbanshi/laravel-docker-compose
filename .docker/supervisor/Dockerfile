FROM php_image

COPY --chmod=0755 \
    supervisor/cmd.sh \
    supervisor/healthcheck.sh \
    /usr/local/bin/

COPY --chmod=0644 supervisor/default.ini /etc/supervisor.d/templates/default.ini.template

RUN apk update && apk add --no-cache supervisor tini gettext

ENTRYPOINT [ "tini", "--" ]

CMD ["cmd.sh"]