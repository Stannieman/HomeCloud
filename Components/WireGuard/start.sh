#! /bin/sh

HOME_DIR=`getent passwd "$(logname)" | cut -d: -f6`
. /ComponentConfigs/WireGuard.hcconfig

echo "$WIREGUARD_CONFIG" > /dev/shm/wireguard.conf
wg-quick up /dev/shm/wireguard.conf