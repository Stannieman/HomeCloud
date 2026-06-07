#! /bin/sh
set -e

composeFiles=$(find /docker -name docker-compose.yml)
dockerComposeCommand="docker-compose"

for composeFile in $composeFiles
do
    dockerComposeCommand="${dockerComposeCommand} -f ${composeFile}"
done

dockerComposeCommand="${dockerComposeCommand} up -d"

echo -e "OPENING ENCRYPTED DRIVE…"
cryptsetup --type luks2 open /dev/sda encryptedsda

echo -e "\n\nIMPORTING ZFS POOL…"
zpool import storage

echo -e "\n\nSTARTING DOCKER CONTAINERS…"
eval $dockerComposeCommand

echo -e "\n\nSUCESSFULLY STARTED!"