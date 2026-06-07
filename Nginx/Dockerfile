FROM alpine:3.13.1

RUN apk add nginx --update-cache;\
adduser mainuser -D -u 1000

ADD nginx.conf /etc/nginx/nginx.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT /start.sh