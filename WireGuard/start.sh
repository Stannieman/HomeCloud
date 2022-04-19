#! /bin/sh

echo $WIREGUARD_CONFIG >> wireguard.conf
wg-quick up /wireguard.conf