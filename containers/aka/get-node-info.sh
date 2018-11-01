#!/bin/sh
enodeid=$(/usr/sbin/geth-akroma attach --datadir /home/akroma/.akroma/ --exec "admin.nodeInfo.id")
enodeid=${enodeid##*$'\n'}

ver=$(./get-version.sh)

printf "  == AKA MASTERNODE DETAILS ==  \n\
enodeid: $enodeid \n\
version: $ver \n\
" > /home/akroma/.akroma/node.info

printf "  == AKA MASTERNODE DETAILS ==  \n\
enodeid: $enodeid \n\
version: $ver \n\
"