ARG IMAGE

FROM ${IMAGE:-php:fpm-alpine}

RUN apk update && apk add --no-cache tini

ENTRYPOINT ["tini", "--"]

CMD ["cmd.sh"]