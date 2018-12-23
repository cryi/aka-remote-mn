#!/bin/sh

# AKROMA REMOTE MASTERNODE SETUP AND MANAGEMENT
# Copyright (C) 2018 cryon.io
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
# 
# Contact: cryi@tutanota.com

if [ -f "/etc/letsencrypt/privkey.pem" ] && [ -f "/etc/letsencrypt/fullchain.pem" ] && [ ! -f "/etc/letsencrypt/temp.certs" ]; then
        /usr/bin/certbot renew --no-self-upgrade --config-dir /home/certbot/ --work-dir /home/certbot/ --logs-dir /home/certbot/
else
        printf "NN" | /usr/bin/certbot certonly --manual --preferred-challenges dns --force-interactive --agree-tos \
        -d remote.akroma.io -d $NODEID.remote.akroma.io --manual-public-ip-logging-ok --email=$email \
        --config-dir /home/certbot/ --work-dir /home/certbot/ --logs-dir /home/certbot/ > certbot.output &

        echo "Waiting for certbot to finish (25s)..."
        sleep 25
        kill -INT $! > /dev/null

        CERTBOT_OUTPUT=$(grep -A 2 'akroma.io' certbot.output | sed "s/akroma.io.*/akroma.io/g" | sed '/^\s*$/d' | sed '/--$/d')
        VALIDATION_URL_1=$(echo "$CERTBOT_OUTPUT" | sed '1q;d')
        VALIDATION_TOKEN_1=$(echo "$CERTBOT_OUTPUT" | sed '2q;d')
        VALIDATION_URL_2=$(echo "$CERTBOT_OUTPUT" | sed '3q;d')
        VALIDATION_TOKEN_2=$(echo "$CERTBOT_OUTPUT" | sed '4q;d')
        VALIDATION_1=$(dig -t txt "$VALIDATION_URL_1" @1.1.1.1 +short | grep -- "$VALIDATION_TOKEN_1" > /dev/null && echo "true" || echo "false")
        VALIDATION_2=$(dig -t txt "$VALIDATION_URL_2" @1.1.1.1 +short | grep -- "$VALIDATION_TOKEN_2" > /dev/null && echo "true" || echo "false")

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
                echo "DNS TXT records not found, please register these dns records (on akroma.io):"
                echo "URL: \"$VALIDATION_URL_1\" - TXT: \"$VALIDATION_TOKEN_1\""
                echo "URL: \"$VALIDATION_URL_2\" - TXT: \"$VALIDATION_TOKEN_2\""
                exit 2
        fi
fi;

newPath=$(ls -t /home/certbot/live | head -1)

privkeyHash=$(sha256sum /home/certbot/live/$newPath/privkey.pem | awk '{ print $1 }')
privkeyHash2=$(sha256sum /etc/letsencrypt/privkey.pem | awk '{ print $1 }')
fullchainHash=$(sha256sum /home/certbot/live/$newPath/fullchain.pem | awk '{ print $1 }')
fullchainHash2=$(sha256sum /etc/letsencrypt/fullchain.pem | awk '{ print $1 }')

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