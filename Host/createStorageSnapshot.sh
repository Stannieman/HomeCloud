#!/bin/sh
set -e

currentDay=$(date +'%A' | tr '[:upper:]' '[:lower:]')

zfs destroy -r "storage@$currentDay"
zfs snapshot -r "storage@$currentDay"