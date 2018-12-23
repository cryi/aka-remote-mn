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
 