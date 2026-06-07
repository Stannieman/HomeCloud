#! /bin/sh
set -e

SCRIPT_PATH=`dirname $(realpath $0)`

apt install wireguard-tools -y
mkdir -p /ComponentConfigs
cp "$SCRIPT_PATH/WireGuard.hcconfig" /ComponentConfigs