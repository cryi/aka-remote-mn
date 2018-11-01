FROM ubuntu:bionic 

# setup dependencies
RUN apt-get update && apt-get upgrade -q -y
RUN apt-get install wget curl libjemalloc1 unzip jq -y

HEALTHCHECK --interval=5s --timeout=1s --retries=5 \
  CMD curl -X POST  --url http://localhost:8545 \
   					--header 'Cache-Control: no-cache' \
				   	--header 'Content-Type: application/json' \
				  	--data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' \
					--silent -k --fail || exit 1

# create user
RUN adduser --disabled-login \
 	 --disabled-password \
	 --gecos "" \
	 --uid 1000 \
	 akroma

# copy necessary scripts
WORKDIR /home/akroma/
COPY get-geth.sh ./get-geth.sh
COPY get-node-info.sh ./get-node-info.sh
COPY get-version.sh ./get-version.sh

# set execution rights
RUN chmod +x ./get-geth.sh ./get-node-info.sh ./get-version.sh

# get latest geth
RUN ./get-geth.sh 
RUN unzip ./geth-akroma.zip
RUN rm -f ./geth-akroma.zip
RUN cp ./geth /usr/sbin/geth-akroma
RUN chmod +x /usr/sbin/geth-akroma

# save node info
RUN mkdir -p /home/akroma/.akroma
RUN echo "  == AKA MASTERNODE DETAILS ==  \
version: $(./get-version.sh) \
" > /home/akroma/.akroma/node.info


# run aka masternode
USER akroma
ENTRYPOINT [ "/usr/sbin/geth-akroma", "--masternode", "--rpcvhosts", "*", "--rpc", "--rpcapi", "eth,net,web3", "--rpcaddr", "0.0.0.0", "--rpccorsdomain", "*", "--atxi", "--atxi.autobuild" ]