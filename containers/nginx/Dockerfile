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