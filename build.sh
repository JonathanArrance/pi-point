#!/bin/bash -x

$INTERFACE='wlan0'
$PRIVATEIP='10.10.10.2'

#pre-reqs
apt update

#set up the private ip addr
ip addr add $PRIVATEIP/24 dev $INTERFACE
echo 'ip addr add $PRIVATEIP/24 dev $INTERFACE' 

