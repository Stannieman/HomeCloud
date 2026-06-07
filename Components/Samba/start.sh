#!/bin/sh

HOME_DIR=`getent passwd "$(logname)" | cut -d: -f6`
. /ComponentConfigs/Samba.hcconfig

(echo $MAIN_USER_PASSWORD; echo $MAIN_USER_PASSWORD) | smbpasswd -s -a mainuser

service nmbd start
service smbd start