FROM php_image

COPY --chmod=0755 \
    cron/cmd.sh \
    cron/healthcheck.sh \
    /usr/local/bin/

ENV DEFAULT_CRONTAB=/etc/crontabs/crontab
ENV WWW_DATA_CRONTAB=/etc/crontabs/www-data

COPY --chmod=0644 cron/crontab $DEFAULT_CRONTAB

RUN apk update && apk add --no-cache tini

ENTRYPOINT ["tini", "--"]

CMD ["cmd.sh"]
