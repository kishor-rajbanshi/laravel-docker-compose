FROM neilpang/acme.sh

# ARG USER_ID
# ARG GROUP_ID

RUN apk update && apk add --no-cache docker-cli #shadow

RUN acme.sh --upgrade --auto-upgrade --server letsencrypt --set-default-ca

# RUN groupadd -g $GROUP_ID acme && useradd -u $USER_ID -g acme -s /bin/sh -m acme;

# USER acme


CMD [ "cmd.sh" ]