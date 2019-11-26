#!/bin/bash

# Notes:
# - Add ability to append clients to an existing configuration hierarchy

## Methods ##


make_server_creds()
{
  mkdir server/
  wg genkey | tee server/privatekey | wg pubkey > server/publickey
}

make_client_configs()
{
  echo -e "\n>Creating Client Configurations..."
  if [ ! -f server/publickey ]; then
    echo ">>Server creds do not exist. Creating now..."
    make_server_creds
  fi

  S_PUBLIC_KEY=$(cat server/publickey)

  for i in $(seq 2 $CONF_COUNT); do
    CLIENT_DIR=client-$i

    if [ -d $CLIENT_DIR ]; then
      echo -e ">>$CLIENT_DIR already exists. Skipping..."

    else
      mkdir $CLIENT_DIR
      wg genkey | tee $CLIENT_DIR/privatekey | wg pubkey > $CLIENT_DIR/publickey
      C_PRIVATE_KEY=$(cat $CLIENT_DIR/privatekey)
      echo -e "[Interface]\nPrivateKey=$C_PRIVATE_KEY\nAddress=192.168.2.$i/32\n\n[Peer]\nPublicKey=$S_PUBLIC_KEY\nAllowedIPs=0.0.0.0/0\nEndpoint=$SERVER_IP:$SERVER_PORT" > $CLIENT_DIR/wg$i.conf
    fi

  done
}

make_server_config()
{
  echo -e "\n>Creating Server Configurations..."
  if [ ! -f server/publickey ]; then
    echo -e ">>Server creds do not exist. Creating now..."
    make_server_creds
  fi

  S_PRIVATE_KEY=$(cat server/privatekey)

  echo -e "[Interface]\nAddress=192.168.2.1/24\nPostUp= iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE\nPostDown= iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE\nListenPort=$SERVER_PORT\nPrivateKey=$S_PRIVATE_KEY" > server/wg0.conf

  for i in $(seq 2 $CONF_COUNT); do
    CURRENT_PUBKEY=$(cat client-$i/publickey)
    echo -e '\n' >> server/wg0.conf
    echo -e "#client-$i" >> server/wg0.conf
    echo -e "[Peer]\nPublicKey=$CURRENT_PUBKEY\nAllowedIPs=192.168.2.$i" >> server/wg0.conf
  done
}

usage()
{
  echo "Usage: generate-wg-configs.sh [-t 'client' | 'server' | 'all'] [-c count] [-d config-directory] -i server-ip-address [-p server-port]"
  echo "Defaults: -t: all,   -c: 1,   -d: configs/,   -p: 6969"
}

## Main ##

CONF_TYPE='all'
CONF_COUNT=1
CONF_DIR='configs/'
SERVER_PORT=6969

while getopts ":t:c:d:i:p:" arg; do
  case $arg in
    t) CONF_TYPE=$OPTARG;;
    c) CONF_COUNT=$OPTARG;;
    d) CONF_DIR=$OPTARG;;
    i) SERVER_IP=$OPTARG;;
    p) SERVER_PORT=$OPTARG;;
  esac
done

# Check for parameter errors
if ((CONF_COUNT < 1)); then
  echo -e "Error: count must be greater than 0\n"
  exit 1
fi

if [ "$SERVER_IP" == '' ]; then
  echo -e "Error: IP cannot be left empty.\n"
  usage
  exit 1
fi

if [ ! -d $CONF_DIR ]; then
  mkdir $CONF_DIR
fi

cd $CONF_DIR
let CONF_COUNT=$CONF_COUNT+1

if [ "$CONF_TYPE" == "client" ]; then
  echo "Creating client configurations..."
  make_client_configs

elif [ "$CONF_TYPE" == "server" ]; then
  echo "Creating server configurations..."
  make_server_config

elif [ "$CONF_TYPE" == "all" ]; then
  echo "Creating client and server configurations..."
  make_client_configs
  make_server_config

else
  echo "Error: Invalid configuration type."
  usage
fi
