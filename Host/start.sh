#! /bin/sh

COMPOSE_FILES=$(find /docker -name docker-compose.yml)
DOCKER_COMPOSE_COMMAND="docker-compose"

for COMPOSE_FILE in $COMPOSE_FILES
do
    DOCKER_COMPOSE_COMMAND="${DOCKER_COMPOSE_COMMAND} -f ${COMPOSE_FILE}"
done

DOCKER_COMPOSE_COMMAND="${DOCKER_COMPOSE_COMMAND} up -d"

zfs mount -l storage/encrypted
eval $DOCKER_COMPOSE_COMMAND