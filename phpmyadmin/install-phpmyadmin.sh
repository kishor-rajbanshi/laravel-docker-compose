#!/bin/sh

PHP_VERSION=$(php -r "echo PHP_VERSION;")

PHP_VERSION_MAJOR_MINOR=$(echo "$PHP_VERSION" | awk -F. '{print $1"."$2}')

if [ "$(echo "$PHP_VERSION_MAJOR_MINOR < 5.3" | bc)" -eq 1 ]; then
  PHPMYADMIN_VERSION="4.0.10.20"
elif [ "$(echo "$PHP_VERSION_MAJOR_MINOR < 5.4" | bc)" -eq 1 ]; then
  PHPMYADMIN_VERSION="4.4.15.10"
elif [ "$(echo "$PHP_VERSION_MAJOR_MINOR < 5.5" | bc)" -eq 1 ]; then
  PHPMYADMIN_VERSION="4.6.6"
elif [ "$(echo "$PHP_VERSION_MAJOR_MINOR < 5.6" | bc)" -eq 1 ]; then
  PHPMYADMIN_VERSION="4.9.11"
elif [ "$(echo "$PHP_VERSION_MAJOR_MINOR < 7.4" | bc)" -eq 1 ]; then
  PHPMYADMIN_VERSION="5.0.4"
elif [ "$(echo "$PHP_VERSION_MAJOR_MINOR < 8.0" | bc)" -eq 1 ]; then
  PHPMYADMIN_VERSION="5.1.0"
else
  PHPMYADMIN_VERSION="5.2.1"
fi

curl -o /var/www/phpMyAdmin.zip https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip

unzip /var/www/phpMyAdmin.zip -d /var/www/

rm /var/www/phpMyAdmin.zip

mv /var/www/phpMyAdmin-* /var/www/phpmyadmin
