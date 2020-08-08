#!/bin/bash -x

$INTERFACE='wlan0'
$PRIVATEIP='10.10.10.2'

#pre-reqs
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo adpt install -y git
sudo apt install -y curl
sudo apt install -y wget

#set up python3
sudo rm /usr/bin/python
sudo ln -s /usr/bin/python3.7 /usr/bin/python

#set up the private ip addr
sudo ip addr add $PRIVATEIP/24 dev $INTERFACE
sudo echo 'ip addr add $PRIVATEIP/24 dev $INTERFACE' 

#install the packages
#Install hostapd and enable at startup
sudo apt install -y hostapd
sudo systemctl unmask hostapd
sudo systemctl enable hostapd

#Install dnsmasq
sudo apt install -y dnsmasq

#Install netfilter and iptables
sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent

#set up dhcpd.conf - set up perm IP for pi-point
