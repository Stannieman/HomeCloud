#! /bin/sh

(echo $MAIN_USER_PASSWORD; echo $MAIN_USER_PASSWORD) | smbpasswd -s -a mainuser

nmbd
smbd --foreground --log-stdout