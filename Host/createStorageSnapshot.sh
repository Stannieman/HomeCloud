#! /bin/sh
set -e

day=$(date +'%A' | tr '[:upper:]' '[:lower:]')

zfs destroy -r "storage@$day"
zfs snapshot -r "storage@$day"