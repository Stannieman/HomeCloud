#!/bin/sh

su mainuser -c 'setsid navidrome --configfile /etc/navidrome/navidrome.toml > /dev/null 2>&1 &'