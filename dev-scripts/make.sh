#!/bin/bash

mkdir server/; cd server/; wg genkey | tee privatekey | wg pubkey > publickey; cd ..
scripts/create-client-configs.sh
scripts/create-server-config.sh
