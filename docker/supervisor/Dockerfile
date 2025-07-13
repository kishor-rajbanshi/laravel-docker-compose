FROM php_image

RUN apk update && apk add --no-cache docker-cli supervisor tini gettext

ENTRYPOINT [ "tini", "--" ]

CMD ["cmd.sh"]