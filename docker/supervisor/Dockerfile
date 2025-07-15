FROM php_image

RUN apk update && apk add --no-cache supervisor tini gettext

ENTRYPOINT [ "tini", "--" ]

CMD ["cmd.sh"]