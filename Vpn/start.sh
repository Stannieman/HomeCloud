#! /bin/sh

echo "$WIREGUARD_CONFIG" > /vpn.conf
wg-quick up /vpn.conf