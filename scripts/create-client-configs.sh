#!/bin/bash

PUBLIC_KEY=$(cat server/publickey) #Server's public key

mkdir host-{2..10}

for i in {2..10}
do
  cd host-$i
  wg genkey | tee privatekey | wg pubkey > publickey
  PRIVATE_KEY=$(cat privatekey) #Client's private key
  echo -e "[Interface]\nPrivateKey=$PRIVATE_KEY\nAddress=192.168.2.$i/32\n\n[Peer]\nPublicKey=$PUBLIC_KEY\nAllowedIPs=0.0.0.0/0\nEndpoint=ufsit.ddns.net:6969" > wg$i.conf
  cd ..
done


