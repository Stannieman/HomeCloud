#! /bin/sh
set -e

echo "\n\nSTOPPING DOCKER CONTAINERS IF NEEDED…"
runningContainers=$(docker ps -q)
if [ "$runningContainers" != "" ]
then
	docker stop $runningContainers
fi

echo "\n\nUPDATING PACKAGE LIST…"
apt update

echo "\n\nUPDATING PACKAGES…"
apt upgrade -y

echo "\n\nREINSTALLING ZFS KERNEL MODULE…"
apt reinstall zfs-dkms -y

echo "\n\nUPDATE COMPLETED, PLEASE REBOOT!"