FROM alpine:3.16.0

RUN apk add nginx=1.22.0-r0 --update-cache;\
adduser mainuser -D -u 1000

ADD nginx.conf /etc/nginx/nginx.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT /start.sh
