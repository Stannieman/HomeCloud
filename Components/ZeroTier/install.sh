#! /bin/sh
set -e

SCRIPT_PATH=`dirname $(realpath $0)`

curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import

if Z=$(curl -s 'https://install.zerotier.com/' | gpg)
then
    echo "$Z" | sudo bash
fi

systemctl stop zerotier-one

cp "$SCRIPT_PATH/ZeroTier.hcconfig" /ComponentConfigs