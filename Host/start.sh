#!/bin/sh
set -e

SCRIPT_PATH=`dirname $(realpath $0)`

echo "\n\nOPENING ENCRYPTED DRIVE…"
cryptsetup --type luks2 --allow-discards open /dev/sda encryptedsda

echo "\n\nIMPORTING ZFS POOL…"
zpool import -f storage

echo "\n\nSTARTING COMPONENTS…"

ENABLED_COMPONENTS=$(find /ComponentConfigs -maxdepth 1 -name '*.hcconfig' -exec basename {} .hcconfig \;)
for ENABLED_COMPONENT in $ENABLED_COMPONENTS
do
    (set +e && . "$SCRIPT_PATH/../Components/$ENABLED_COMPONENT/start.sh")
done

echo "\n\nSUCCESSFULLY STARTED!"