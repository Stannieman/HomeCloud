#!/bin/sh
set -e

SCRIPT_PATH=`dirname $(realpath $0)`
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

echo "\n\nSTOPPING COMPONENTS…"
ENABLED_COMPONENTS=$(find /ComponentConfigs -maxdepth 1 -name '*.hcconfig' -exec basename {} .hcconfig \;)
for ENABLED_COMPONENT in $ENABLED_COMPONENTS
do
    (set +e && . "$SCRIPT_PATH/../Components/$ENABLED_COMPONENT/stop.sh")
done

echo "\n\nUPDATING PACKAGE LIST…"
apt update
su mainuser -c 'brew update'

echo "\n\nUPDATING PACKAGES…"
apt upgrade -y
su mainuser -c 'brew upgrade --greedy'

echo "\n\nCLEANING UP…"
apt clean
su mainuser -c 'brew autoremove'
su mainuser -c 'brew cleanup'
rm -rf ~/Library/Caches/Homebrew/downloads

echo "\n\nREBOOTING…"
reboot