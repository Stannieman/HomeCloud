#! /bin/sh
set -e

COMPOSE_FILES=$(find /docker -name docker-compose.yml)
DOCKER_COMPOSE_COMMAND="docker-compose"

for COMPOSE_FILE in $COMPOSE_FILES
do
    DOCKER_COMPOSE_COMMAND="${DOCKER_COMPOSE_COMMAND} -f ${COMPOSE_FILE}"
done

DOCKER_COMPOSE_COMMAND="${DOCKER_COMPOSE_COMMAND} up -d"

echo Opening encrypted drive…
cryptsetup --type luks2 open /dev/sda encryptedsda

echo Importing ZFS pool…
zpool import storage

echo Starting Docker containers…
eval $DOCKER_COMPOSE_COMMAND