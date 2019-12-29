#!/bin/bash



## Helper scripts ##

warn(){
    echo -e "WARN: $1"
}

fatal(){
    echo -e "FATAL: $1"
    exit 1
}

usage(){
    echo "Usage: wg-man "
}

## Main ##
