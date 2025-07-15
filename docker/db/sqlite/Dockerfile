FROM alpine

RUN apk update && apk add --no-cache curl jq

COPY db/sqlite/cmd.sh /usr/local/bin/

HEALTHCHECK --interval=1s --timeout=3s \
    CMD true

CMD ["cmd.sh"]