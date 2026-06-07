#! /bin/sh
set -e

echo -e "Stopping Docker containers…"
docker stop $(sudo docker ps -q)

echo -e "\n\nUPDATING PACKAGE LIST…"
apt update

echo -e "\n\nUPDATING PACKAGES…"
apt upgrade -y

REINSTALLING ZFS KERNEL MODULE…"
apt reinstall zfs-dkms -y