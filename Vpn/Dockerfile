FROM alpine:3.15.4

RUN apk add wireguard-tools=1.0.20210914-r0 --update-cache

ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT /start.sh