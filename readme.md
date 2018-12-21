## AKROMA REMOTE MASTERNODE SETUP © cryon.io 2018

### Automated setup (ubuntu and derivatives with apt & sudo)

0. `git clone "https://github.com/cryi/aka-remote-mn.git" && cd aka-remote-mn`
1. `sudo chmod +x ./configurator`
2. generate fake enodeid and use it to register remote node in akroma.io 
    `./configurator --generate-fake-enodeid` 
3. Fill data and nodeid from akroma.io and your email for obtaining letsencrypt certificates and optinaly port
    `./configurator --data=[data] --nodeid=[nodeid] --email=[email] --port=[port]`
    - data is **TRANSACTION DATA**
    - nodeid is number defined in **MASTERNODE** field (top most one) in akroma.io node overview
    - email has to be valid email address 
    - port (optional), sets RPC port for masternode (default 8545). 
3. `sudo ./configurator --full --user=[user]` 
4. Update enodeid and port in akroma.io
    - setup outputs node info at the end, you can also find it inside file `./data/node.info` (`cat ./data/node.info`)
    - setup also outputs DNS TXT records
    - user (optional) is user used to execute and update MN
5. Submit dns TXT challenge to akroma.io
    - you can find it at the end of setup (if it is not found in DNS records)
    - you can find it also in `./letsencrypt/certbot/certbot.output`
6. Verify DNS TXT records propagation (takes up to 3 hours to propagate)
    `./configurator --verify-dns`
    - wait for `STATUS: propagated`
7. Get valid certificates with `./configurator -c`
    - valid certificates will be issued only if there are already valid DNS TXT records found
8. You can use `./configurator -s` to verify RemoteNode validity
    - __LOCAL HTTPS__ test signs working node locally 
    - __REMOTE HTTPS__ test signs propagated dns record for your [nodeid].remote.akroma.io
    - __CERTIFICATE VALIDITY__ test signs the node has valid certificates
9. **Only node which passes all test will be considered functional**

### Manual setup (other systems)

#### WARNING: These steps may differ based on your OS. This setup is recommended ONLY for advanced users.

##### install docker 
0. install docker according to the official documentation (https://docs.docker.com/install/)

1. install docker compose  
    - for linux systems: `curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose`
    - (only on unix based systems) `chmod +x /usr/local/bin/docker-compose`
2.  `docker-compose --version` # Verifying if docker-compose works correctly

##### setup && start masternode
0. a) set write permissions for user id 1000 for directory `./data`
    - on unix based systems with POSIX shell you can use: `sh ./tools/allow_container_write.sh -f -p ./data`
    - (non default) if you use user remap feature in docker, set allow write permission for user **remap id + 1000** 
0. b) replace email, nodeid and data with proper values
    - nodeid and email in `./containers/certbot/docker-compose.yml`
    - nodeid and data in `./containers/nginx/conf.d/aka.conf`
1. generate temporary certificates (masternode nginx wont run without them)
    - `./letsencrypt/fullchain.pem` # required by nginx container 
    - `./letsencrypt/privkey.pem`   # required by nginx container
2. `docker-compose up -d` # builds and starts masternode
3. you can test masternode responding to https on https://127.0.0.1/client 
4. `docker-compose -f "$certbotComposeFile" run certbot` # prints challenges/obtains certificites.
5. when you got valid certificates (DNS TXT challenges are not printed anymore), restart RemoteNode with `docker-compose up -d --force-recreate`
6. Your node should be fully functional now.

### good to know
- `docker-compose down`     # stops masternode
- `docker-compose up`       # starts masternode with log output into console
- `docker-compose up -d`    # starts masternode in detached mode (no console output)
- `docker-compose logs`     # displays log output from services
- `docker exec --user akroma -it [container id] bash` # opens bash inside container
- `docker ps`               # lists running containers (you can find out container id in left column)
- `wget --no-cache --no-cookies https://raw.githubusercontent.com/cryi/aka-remote-mn/master/configurator -O ./configurator && chmod +x ./configurator`    # updates configurator
