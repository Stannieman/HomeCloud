#! /bin/sh
set -e

composeFiles=$(find /docker -name docker-compose.yml)
dockerComposeCommand="docker-compose"

for composeFile in $composeFiles
do
    dockerComposeCommand="${dockerComposeCommand} -f ${composeFile}"
done

dockerComposeCommand="${dockerComposeCommand} up -d"

echo "\n\nOPENING ENCRYPTED DRIVE…"
cryptsetup --type luks2 open /dev/sda encryptedsda

echo "\n\nIMPORTING ZFS POOL…"
zpool import storage

echo "\n\nSTARTING DOCKER CONTAINERS…"
sleep 30
eval $dockerComposeCommand

echo "\n\nSUCESSFULLY STARTED!"