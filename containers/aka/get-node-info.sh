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