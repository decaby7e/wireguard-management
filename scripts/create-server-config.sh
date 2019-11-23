#!/bin/bash

PRIVATE_KEY=$(cat server/privatekey)

echo -e "[Interface]\nAddress=192.168.2.1/24\nPostUp= iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE\nPostDown= iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE\nListenPort=6969\nPrivateKey=$PRIVATE_KEY" > server/wg0.conf

for i in {2..10}
do
  CURRENT_PUBKEY=$(cat host-$i/publickey)
  echo -e '\n' >> server/wg0.conf
  echo -e "host-$i" >> server/wg0.conf
  echo -e "[Peer]\nPublicKey=$CURRENT_PUBKEY\nAllowedIPs=192.168.2.$i" >> server/wg0.conf
done

exit 0
