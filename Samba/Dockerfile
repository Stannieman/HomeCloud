FROM alpine:3.15.2

RUN apk add samba=4.15.5-r0 --update-cache;\
# This assumes the mainuser on the host has user and group id 1000.
# By using the same id we ensure the SMB user can access the data.
adduser mainuser -D -u 1000

ADD smb.conf /etc/samba/smb.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT /start.sh