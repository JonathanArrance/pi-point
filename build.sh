#!/bin/bash -x

INTERFACE='wlan0'
PRIVATEIP='10.10.10.2'
PASSPHRASE='password'
SSID='KickAss'

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
#sudo ip addr add $PRIVATEIP/24 dev $INTERFACE
#sudo echo 'ip addr add $PRIVATEIP/24 dev $INTERFACE' 

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
(
cat   << 'EOF'
interface wlan0
    static ip_address=${PRIVATEIP}/24
    nohook wpa_supplicant
EOF
) >> /etc/dhcpd.conf

#set up ip forwarding
#(
#cat << 'EOF'
#net.ipv4.ip_forward=1
#EOF
#) >> /etc/sysctl.d/routed-ap.conf

#Set the iptables firewall
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE

#set the rules
sudo netfilter-persistent save

#set up dhcp
(
sudo cat << 'EOF'
interface=wlan0
dhcp-range=${PRIVATEIP},10.10.10.200,255.255.255.0,24h
domain=wlan
address=/gw.wlan/10.10.10.1
EOF
) >> /etc/dnsmasq.conf

#Set up access point
(
sudo cat << 'EOF'
interface=wlan0
ssid=${SSID}
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=${PASSPHRASE}
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF
) >> /etc/hostapd/hostapd.conf
