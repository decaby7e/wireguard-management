#!/bin/bash

# PARAMETERS: make_client_config(SERVER_PUBKEY, SERVER_IP, SERVER_PORT)
make_client_config() {
    
    
    if ( (($# != 4)) ); then
        echo "Error: Not enough parameters."
        usage
        exit 1

    fi

    CLIENT_DIR=client-$CLIENT_NUM

    if [ -d $CLIENT_DIR ]; then
        echo -e "Error: $CLIENT_DIR already exists. Not overwriting."
        exit 1
        
    else
        S_PUBKEY=$1
        SERVER_IP=$2
        SERVER_PORT=$3
        CLIENT_NUM=$4

        mkdir $CLIENT_DIR
        wg genkey | tee $CLIENT_DIR/privatekey | wg pubkey > $CLIENT_DIR/publickey

        C_PRIVATE_KEY=$(cat $CLIENT_DIR/privatekey)
        C_PUBLIC_KEY=$(cat $CLIENT_DIR/publickey)

        echo -e "[Interface]\nPrivateKey=$C_PRIVATE_KEY\nAddress=192.168.2.$CLIENT_NUM/32\n\n[Peer]\nPublicKey=$S_PUBKEY\nAllowedIPs=0.0.0.0/0\nEndpoint=$SERVER_IP:$SERVER_PORT" > $CLIENT_DIR/wg$CLIENT_NUM.conf
        
        echo -e "Client successfully written to $CLIENT_DIR/wg$CLIENT_NUM.conf"
        echo    ""
        echo    "Server entry for this client:"
        echo    ""
        echo -e "#client-$CLIENT_NUM"
        echo -e "[Peer]\nPublicKey=$C_PUBLIC_KEY\nAllowedIPs=192.168.2.$CLIENT_NUM"
        echo    ""
        
        exit 0

    fi
}

usage() {
    echo ""
    echo "Usage: generate-wg-client.sh [-s server-public-key -a server-address -p server-port -c client-number]"
    echo ""
    echo "Example: generate-wg-client.sh -s serverpublickey -a example.com -p 51820 -c 128"
}

while getopts ":s:a:p:c:" arg; do
  case $arg in
    s) SERVER_KEY=$OPTARG;;
    a) SERVER_IP=$OPTARG;;
    p) SERVER_PORT=$OPTARG;;
    c) CLIENT_NUM=$OPTARG;;
  esac
done

make_client_config $SERVER_KEY $SERVER_IP $SERVER_PORT $CLIENT_NUM