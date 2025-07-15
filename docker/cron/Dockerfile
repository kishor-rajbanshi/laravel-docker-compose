FROM php_image

RUN apk update && apk add --no-cache tini

ENTRYPOINT ["tini", "--"]

CMD ["cmd.sh"]