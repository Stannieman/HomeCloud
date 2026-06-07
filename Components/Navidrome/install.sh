#!/bin/bash
set -e

SCRIPT_PATH=`dirname $(realpath $0)`
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

su mainuser -c 'brew install navidrome'
mkdir -p /etc/navidrome
cp "$SCRIPT_PATH/navidrome.toml" /etc/navidrome/navidrome.toml
mkdir -p /ComponentConfigs
cp "$SCRIPT_PATH/Navidrome.hcconfig" /ComponentConfigs