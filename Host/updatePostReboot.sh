#!/bin/sh
set -e

echo "\n\nREINSTALLING ZFS KERNEL MODULE…"
apt reinstall zfs-dkms -y

echo "\n\nUPDATE COMPLETED, REBOOTING…"
reboot