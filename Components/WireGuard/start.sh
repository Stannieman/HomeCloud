#! /bin/sh

. /ComponentConfigs/WireGuard.hcconfig

echo "$WIREGUARD_CONFIG" > /dev/shm/wg0.conf
wg-quick up /dev/shm/wg0.conf