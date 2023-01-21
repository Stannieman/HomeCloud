#! /bin/sh

. /ComponentConfigs/ZeroTier.hcconfig

systemctl start zerotier-one

while [[ $(systemctl show -p SubState --value zerotier-one) != "running" ]]
do
  sleep 1
done

zerotier-cli join "$ZEROTIER_NETWORK_ID"
