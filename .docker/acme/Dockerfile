FROM neilpang/acme.sh

ARG USER_ID
ARG GROUP_ID

COPY --chmod=0755 cmd.sh /usr/local/bin/

RUN addgroup -g ${GROUP_ID} acme \
    && adduser -D -u ${USER_ID} -G acme acme

RUN acme.sh  --set-default-ca  --server letsencrypt

CMD [ "cmd.sh" ]
