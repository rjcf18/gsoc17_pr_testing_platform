#!/usr/bin/env bash

##########################
# This script will be located on the devilbox base folder

PHP_VERSION=$1
INSTANCE_ID=$2
DOMAIN="domain"
DB_PASSWORD="password"
DB_NAME="joomla-${INSTANCE_ID}"
INSTANCE_FOLDER=${INSTANCE_ID}.${DOMAIN}
HOST_INSTANCE_FOLDER=data/www/php${PHP_VERSION}/${INSTANCE_FOLDER}

docker-compose exec -d --user root php${PHP_VERSION} env TERM=xterm /bin/sh -c "
mysql --user=root --password=${DB_PASSWORD} --host=127.0.0.1 -e 'DROP DATABASE \`${DB_NAME}\`;';
"

echo "Database ${DB_NAME} for this instance dropped."

rm -R ${HOST_INSTANCE_FOLDER}

echo "Joomla instance folder in data/www/php${PHP_VERSION}/ removed."
