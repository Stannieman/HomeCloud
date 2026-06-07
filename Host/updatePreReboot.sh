#! /bin/sh
set -e

SCRIPT_PATH=`dirname $(realpath $0)`

echo "\n\nSTOPPING COMPONENTS…"
ENABLED_COMPONENTS=$(find /ComponentConfigs -maxdepth 1 -name '*.hcconfig' -exec basename {} .hcconfig \;)
for ENABLED_COMPONENT in $ENABLED_COMPONENTS
do
    (set +e && . "$SCRIPT_PATH/../Components/$ENABLED_COMPONENT/stop.sh")
done

echo "\n\nUPDATING PACKAGE LIST…"
apt update

echo "\n\nUPDATING PACKAGES…"
apt upgrade -y

echo "\n\nREBOOTING…"
reboot