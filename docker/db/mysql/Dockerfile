ARG DB_VERSION

FROM mysql:${DB_VERSION:-latest}

ARG USER_ID
ARG GROUP_ID

COPY ./permissions.sh /usr/local/bin/
COPY ./db/mysql/cmd.sh /usr/local/bin/

RUN permissions.sh mysql

HEALTHCHECK CMD sh -c 'mysqladmin ping -h 127.0.0.1 -u root --password="$MYSQL_ROOT_PASSWORD" || exit 1'

CMD ["cmd.sh"]