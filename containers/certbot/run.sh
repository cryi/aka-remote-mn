#!/bin/sh

if [ -f "/etc/letsencrypt/privkey.pem" ] && [ -f "/etc/letsencrypt/fullchain.pem" ] && [ ! -f "/etc/letsencrypt/temp.certs" ]; then
        /usr/bin/certbot renew --no-self-upgrade --config-dir /home/certbot/ --work-dir /home/certbot/ --logs-dir /home/certbot/
else
        printf "N\n" | /usr/bin/certbot certonly --manual --preferred-challenges dns --force-interactive --agree-tos \
        -d remote.akroma.io -d $NODEID.remote.akroma.io --manual-public-ip-logging-ok --email=$email \
        --config-dir /home/certbot/ --work-dir /home/certbot/ --logs-dir /home/certbot/ > certbot.output &

        echo "Waiting for certbot to finish (25s)..."
        sleep 25
        kill -INT $! > /dev/null

        CERTBOT_OUTPUT=$(grep -A2 'akroma.io' certbot.output | sed "s/akroma.io.*/akroma.io/g" | sed '/^\s*$/d' | sed '/--$/d')
        VALIDATION_URL_1=$(echo "$CERTBOT_OUTPUT" | sed '1q;d')
        VALIDATION_TOKEN_1=$(echo "$CERTBOT_OUTPUT" | sed '2q;d')
        VALIDATION_URL_2=$(echo "$CERTBOT_OUTPUT" | sed '3q;d')
        VALIDATION_TOKEN_2=$(echo "$CERTBOT_OUTPUT" | sed '4q;d')
        VALIDATION_1=$(dig -t txt "$VALIDATION_URL_1" +short | grep "$VALIDATION_TOKEN_1" > /dev/null && echo "true" || echo "false")
        VALIDATION_2=$(dig -t txt "$VALIDATION_URL_2" +short | grep "$VALIDATION_TOKEN_2" > /dev/null && echo "true" || echo "false")

        if [ -z "$VALIDATION_URL_1" ] || [ -z "$VALIDATION_URL_2" ]; then
                cat certbot.output | echo
                exit 3
        fi 

        if [ "$VALIDATION_1" = "true" ] &&  [ "$VALIDATION_2" = "true" ]; then
                echo "DNS TXT records found, obtaining certificates."
                toPrint="N\n\n"
                printf $toPrint | /usr/bin/certbot certonly --manual --preferred-challenges dns --force-interactive --agree-tos \
                -d remote.akroma.io -d $NODEID.remote.akroma.io --manual-public-ip-logging-ok --email=$email \
                --config-dir /home/certbot/ --work-dir /home/certbot/ --logs-dir /home/certbot/
        else
                echo "DNS TXT records not found, please register these dns records:"
                echo "URL: \"$VALIDATION_URL_1\" - TXT: \"$VALIDATION_TOKEN_1\""
                echo "URL: \"$VALIDATION_URL_2\" - TXT: \"$VALIDATION_TOKEN_2\""
                exit 2
        fi
fi;

newPath=$(ls -t /home/certbot/live | head -1)

privkeyHash=$(sha1sum /home/certbot/live/$newPath/privkey.pem | awk '{ print $1 }')
privkeyHash2=$(sha1sum /etc/letsencrypt/privkey.pem | awk '{ print $1 }')
fullchainHash=$(sha1sum /home/certbot/live/$newPath/fullchain.pem | awk '{ print $1 }')
fullchainHash2=$(sha1sum /etc/letsencrypt/fullchain.pem | awk '{ print $1 }')

returnval=0
if [ ! -f "/etc/letsencrypt/fullchain.pem" ] || [ ! "$fullchainHash" = "$fullchainHash2" ]; then
        echo "Exporting new fullchain.pem (/home/certbot/live/$newPath/fullchain.pem)..."
        cp -f /home/certbot/live/$newPath/fullchain.pem /etc/letsencrypt/
        rm -f "/etc/letsencrypt/temp.certs"
        returnval=1
fi;
if [ ! -f "/etc/letsencrypt/privkey.pem" ] || [ ! "$privkeyHash" = "$privkeyHash2" ]; then
        echo "Exporting new privkey.pem (/home/certbot/live/$newPath/privkey.pem)..."
        cp -f /home/certbot/live/$newPath/privkey.pem /etc/letsencrypt/
        rm -f "/etc/letsencrypt/temp.certs"
        returnval=1
fi;
echo "certificates updated"
exit $returnval