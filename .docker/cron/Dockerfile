FROM php_image

COPY --chmod=0755 \
    cron/cmd.sh \
    cron/healthcheck.sh \
    /usr/local/bin/

COPY --chmod=0644 cron/crontab /etc/crontabs/crontab

RUN apk update && apk add --no-cache tini

ENTRYPOINT ["tini", "--"]

CMD ["cmd.sh"]
