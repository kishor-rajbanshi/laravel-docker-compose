ARG IMAGE

FROM ${IMAGE:-php:fpm-alpine}

COPY ./phpmyadmin/cmd.sh /tmp/cmd.sh
COPY ./phpmyadmin/install-phpmyadmin.sh /tmp/install-phpmyadmin.sh
COPY ./build.d/phpmyadmin.sh /tmp/configure.sh

RUN /tmp/install-phpmyadmin.sh

COPY ./conf.d/phpmyadmin.config.inc.php /var/www/phpmyadmin/config.inc.php

RUN /tmp/configure.sh

CMD ["/tmp/cmd.sh"]