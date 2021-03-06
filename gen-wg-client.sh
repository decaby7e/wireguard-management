#!/bin/bash

. common.sh

# gen_client_config(S_PUBKEY, S_IP, S_PORT, C_IP, C_NAME, C_FILE)
gen_client_config() {
    if ( (($# < 6)) ); then
        fatal 'Not enough parameters'
    fi

    S_PUBKEY=$1
    S_IP=$2
    S_PORT=$3
    C_IP=$4
    C_NAME=$5
    C_FILE=$6

    if [ -f $C_FILE ]; then
        fatal "$C_FILE already exists. Not overwriting."
    else
        touch $C_FILE
    fi

    C_PRIVKEY=$(wg genkey)
    C_PUBKEY=$(echo $C_PRIVKEY | wg pubkey)

    echo -e "# Auto-Generated by script\n\n#$C_NAME\n[Interface]\nPrivateKey=$C_PRIVKEY\n#PublicKey=$C_PUBKEY\nAddress=$C_IP/32\n\n[Peer]\nPublicKey=$S_PUBKEY\nAllowedIPs=0.0.0.0/0\nEndpoint=$S_IP:$S_PORT" > $C_FILE
    
    info "$C_NAME configuration successfully written to $C_FILE"
    info "Server entry for this client:\n"

    printf "#$C_NAME\n"
    printf "[Peer]\nPublicKey=$C_PUBKEY\nAllowedIPs=$C_IP\n\n"
    
    exit 0
}

while getopts ":s:a:p:c:f:n:" arg; do
  case $arg in
    s) S_PUBKEY=$OPTARG;;
    a) S_IP=$OPTARG;;
    p) S_PORT=$OPTARG;;
    c) C_IP=$OPTARG;;
    f) C_FILE=$OPTARG;;
    n) C_NAME=$OPTARG;;
  esac
done

gen_client_config $S_PUBKEY $S_IP $S_PORT $C_IP $C_NAME $C_FILE