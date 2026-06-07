#!/bin/sh
set -e

SCRIPT_PATH=`dirname $(realpath $0)`

apt install samba -y
systemctl stop nmbd smbd
systemctl disable nmbd smbd
cp "$SCRIPT_PATH/smb.conf" /etc/samba/smb.conf
mkdir -p /ComponentConfigs
cp "$SCRIPT_PATH/Samba.hcconfig" /ComponentConfigs