#!/bin/bash

INTERFACE_NUM=$1
CLIENT_NAME=$2

if [ ! -d "host-$INTERFACE_NUM" ] || [ -d "host-$INTERFACE_NUM-registered" ]; then
    echo "Error: Client is registered already"

    else
      INTERFACE_CONF=host-$INTERFACE_NUM/wg$INTERFACE_NUM.conf
      DATE=$(date +"%D %T")

      echo -e "#Client $CLIENT_NAME registered on $DATE to wg$INTERFACE_NUM" | cat - $INTERFACE_CONF > temp && mv temp $INTERFACE_CONF
      echo -e "Client $CLIENT_NAME registered on $DATE to wg$INTERFACE_NUM" >> registered-clients

      mv host-$INTERFACE_NUM host-$INTERFACE_NUM-registered

fi

exit 0
