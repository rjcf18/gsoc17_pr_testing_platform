#!/usr/bin/env bash

##########################
# This script will be located on the devilbox base folder

PR_ID=$1
PHP_VERSION=$2
INSTANCE_ID=$3
DOMAIN="domain"
REPOSITORY="repository"
DB_PASSWORD="password"
DB_NAME="joomla-${INSTANCE_ID}"
INSTANCE_FOLDER=${INSTANCE_ID}.${DOMAIN}
HOST_INSTANCE_FOLDER=data/www/php${PHP_VERSION}/${INSTANCE_FOLDER}/htdocs

####################################
# Creates folder for joomla instance

mkdir data/www/php${PHP_VERSION}/${INSTANCE_FOLDER}/
mkdir data/www/php${PHP_VERSION}/${INSTANCE_FOLDER}/htdocs

####################################################################
# Copies the PR code from jenkins workspace into the instance folder

cp -r data/jenkins/workspace/${REPOSITORY}/origin/pr/${PR_ID}/merge/. ${HOST_INSTANCE_FOLDER}/
#git clone --depth 1 -b 4.0-dev --single-branch https://github.com/joomla/joomla-cms.git ${HOST_INSTANCE_FOLDER}

echo "Joomla PR code placed in the instance folder in data/www/php${PHP_VERSION}/ folder."

cp files/users.sql ${HOST_INSTANCE_FOLDER}/installation/sql/mysql

cp files/configuration.php ${HOST_INSTANCE_FOLDER}

sed -i 's/#__/jos_/g' ${HOST_INSTANCE_FOLDER}/installation/sql/mysql/joomla.sql
sed -i 's/#__/jos_/g' ${HOST_INSTANCE_FOLDER}/installation/sql/mysql/sample_testing.sql
sed -i 's/#__/jos_/g' ${HOST_INSTANCE_FOLDER}/installation/sql/mysql/users.sql

####################################################################
# Places DB info and instance path in the joomla conf file

sed -i "s/\${DBPASSWORD}/${DB_PASSWORD}/g" ${HOST_INSTANCE_FOLDER}/configuration.php
sed -i "s/\${DBNAME}/${DB_NAME}/g" ${HOST_INSTANCE_FOLDER}/configuration.php
sed -i "s/\${INSTANCEFOLDER}/${INSTANCE_FOLDER}/g" ${HOST_INSTANCE_FOLDER}/configuration.php

echo "Configuration file generated in the Joomla instance base folder."

##################################################
# Sets up folder permissions and the DB

docker-compose exec -d --user root php${PHP_VERSION} env TERM=xterm /bin/sh -c "cd /shared/httpd;
chown -R devilbox:devilbox ${INSTANCE_FOLDER}/;
chmod -R 755 ${INSTANCE_FOLDER}/;
mysql --user=root --password=${DB_PASSWORD} --host=127.0.0.1 -e 'CREATE DATABASE \`${DB_NAME}\`;';

mysql --user=root --password=${DB_PASSWORD} --host=127.0.0.1 ${DB_NAME} < ${INSTANCE_FOLDER}/htdocs/installation/sql/mysql/joomla.sql;
mysql --user=root --password=${DB_PASSWORD} --host=127.0.0.1 ${DB_NAME} < ${INSTANCE_FOLDER}/htdocs/installation/sql/mysql/sample_testing.sql;
mysql --user=root --password=${DB_PASSWORD} --host=127.0.0.1 ${DB_NAME} < ${INSTANCE_FOLDER}/htdocs/installation/sql/mysql/users.sql ;
"

echo "Database ${DB_NAME} and tables created, and data imported to the database."
