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

script_usage() {
    cat << EOF
Allows write for user id 1000 (or remap uid +1000) inside containers

Usage:
     -h|--help                  Displays this help
     -p=[path]|--path=[path]    Sets rights for specified file/directory
     -f|--force                 Wont ask for confirmation
EOF
}

parse_params() {
    while :; do
        case $1 in
            -h|--help)
                script_usage
                exit 0
                ;;
            -f|--force)
                force=true
                shift
                ;;
            -p=*|--path=*)
                path=$(echo $1 | sed 's/-p=//g')
                path=$(echo $path | sed 's/--path=//g')
                echo $path
                shift
                ;;
            -?*)
                echo "Invalid parameter was provided: $1"
                exit 2
                ;;
            *)
                break;
        esac
    done
}

parse_params "$@"

if [ ! -d "$path" ] && [ ! -f "$path" ]; then
        echo "Path '$path' not found!";
        exit;
fi;
uid=$(grep "dockremap" /etc/subuid)
uid=$(echo $uid | cut -d ":" -f 2)
uid=$(($uid + 1000))

if [ "$force" = "true" ]; then
    REPLY="y"
else
    echo "Do you really make '$path' writable from containers (!!! do not use for system folders !!!)? (y/N) "
    read REPLY
    echo
fi
if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
    chown -R $uid:$uid $path &&  echo "Access permission to '$path' set to uid $uid (allows container to write into fs)"
    exit $?
fi
