#! /bin/sh
set -e

composeFiles=$(find /docker -name docker-compose.yml)
dockerComposeCommand="docker-compose"

for composeFile in $composeFiles
do
    dockerComposeCommand="${dockerComposeCommand} -f ${composeFile}"
done

dockerComposeCommand="${dockerComposeCommand} up -d"

echo Opening encrypted drive…
cryptsetup --type luks2 open /dev/sda encryptedsda

echo Importing ZFS pool…
zpool import storage

echo Starting Docker containers…
eval $dockerComposeCommand