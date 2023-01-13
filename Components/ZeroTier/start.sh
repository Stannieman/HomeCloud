#! /bin/sh

. /ComponentConfigs/ZeroTier.hcconfig

systemctl start zerotier-one
zerotier-cli join "$ZEROTIER_NETWORK_ID"