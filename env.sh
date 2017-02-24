#!/bin/sh

SOURCE_ENV_PATH=./env_files/$1
DESTINATION_ENV_FILE=./.env

/bin/rm -f $DESTINATION_ENV_FILE && touch $DESTINATION_ENV_FILE
echo "PLATFORM=$1" > $DESTINATION_ENV_FILE
cat $SOURCE_ENV_PATH/common.env >> $DESTINATION_ENV_FILE
ELK_NETWORKS=$(grep "^ELK_NETWORKS" $DESTINATION_ENV_FILE | cut -d '=' -f 2 -)
COMPOSE_PROJECT_NAME=$(grep "^COMPOSE_PROJECT_NAME" $DESTINATION_ENV_FILE | cut -d '=' -f 2 -)
sed -i "/^networks:/{n;s/.*/  $ELK_NETWORKS:/g}" docker-compose.override.yml
sed -i "/^networks:/{n;s/.*/  $COMPOSE_PROJECT_NAME\_$ELK_NETWORKS:/g}" logstash-shipper.yml
