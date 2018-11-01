FROM certbot/certbot

RUN apk add --no-cache certbot
RUN apk add --no-cache bind-tools

RUN adduser -s -H -D -u 1000 certbot

USER certbot
WORKDIR /home/certbot 
ENTRYPOINT [ "/bin/sh", "/home/certbot/run.sh" ]