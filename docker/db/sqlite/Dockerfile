FROM alpine

RUN apk update && apk add --no-cache docker-cli

COPY db/sqlite/entrypoint.sh /usr/local/bin/

HEALTHCHECK --interval=1s --timeout=3s \
    CMD true

ENTRYPOINT ["entrypoint.sh"]
