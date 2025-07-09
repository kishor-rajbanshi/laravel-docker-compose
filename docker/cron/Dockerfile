FROM php_image

RUN apk update && apk add --no-cache tini docker-cli

ENTRYPOINT ["tini", "--"]

CMD ["cmd.sh"]