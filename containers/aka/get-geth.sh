#!/bin/sh
platform=$(uname -m)
ver=$(curl -L -s "https://raw.githubusercontent.com/akroma-project/akroma/master/versions.json" | jq '.stable' --raw-output)
case $platform in
    "x86_64")
        platform="amd64"
        ;;
    "armv5l")
        platform="arm-5"
        ;;
    "armv6l")
        platform="arm-6"
        ;;
    "armv7l")
        platform="arm-7"
        ;;
    "armv8l")
        platform="arm-8"
        ;;
    "aarch64")
        platform="arm-64"
        ;;
    "i686")
        platform="386"
        ;;
    *)
        echo "Unsupported OS ($platform) for geth.  You may need to setup akromanode manually."
        exit 2
        ;;
esac
curl -L "https://github.com/akroma-project/akroma/releases/download/$ver/release.linux-$platform.$ver.zip" -o ./geth-akroma.zip
 