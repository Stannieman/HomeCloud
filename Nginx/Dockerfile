FROM alpine:3.14.0

RUN apk add nginx=1.20.1-r3 --update-cache;\
adduser mainuser -D -u 1000

ADD nginx.conf /etc/nginx/nginx.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT /start.sh