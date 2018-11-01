
if [ ! -f "/certs/privkey.pem" ] || [ ! -f "/certs/fullchain.pem" ]; then
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
        -subj "/C=EU/ST=EU/L=EU/O=cryon.io/CN=remote.akroma.io" \
        -keyout /certs/privkey.pem -out /certs/fullchain.pem

    echo "These temp certificates, which has to be replaced by certbot container." > /certs/temp.certs
fi