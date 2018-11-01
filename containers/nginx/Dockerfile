FROM nginx:alpine

RUN apk add --no-cache curl

RUN adduser -s -H -D -u 1000 aka_nginx
HEALTHCHECK --interval=5s --timeout=2s --retries=6 \
  CMD curl --silent -k --fail https://localhost:8443/ || exit 1

RUN mkdir -p /nginx/log && \
  chown -R aka_nginx:aka_nginx /nginx/log
RUN mkdir -p /nginx/run && \
  chown -R aka_nginx:aka_nginx /nginx/run
RUN mkdir -p /nginx/aka_cache && \
  chown -R aka_nginx:aka_nginx /nginx/aka_cache

COPY gen-temp-certs.sh /home/aka_nginx/gen-temp-certs.sh
RUN chmod +x /home/aka_nginx/gen-temp-certs.sh

RUN chown -R aka_nginx:aka_nginx  /var/cache/

USER aka_nginx