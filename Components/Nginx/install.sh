#! /bin/sh
set -e

SCRIPT_PATH=`dirname $(realpath $0)`

apt install nginx -y
systemctl disable nginx
cp "$SCRIPT_PATH/nginx.conf" /etc/nginx/nginx.conf
mkdir -p /ComponentConfigs
cp "$SCRIPT_PATH/Nginx.hcconfig" /ComponentConfigs