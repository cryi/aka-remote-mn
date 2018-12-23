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

FROM certbot/certbot

RUN apk add --no-cache certbot
RUN apk add --no-cache bind-tools

RUN adduser -s -H -D -u 1000 certbot

USER certbot
WORKDIR /home/certbot 
ENTRYPOINT [ "/bin/sh", "/home/certbot/run.sh" ]