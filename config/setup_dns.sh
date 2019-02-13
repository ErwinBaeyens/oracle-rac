#!/bin/bash

set -e

# set some colours for the echo commands
green=$(tput setaf 2)
red=$(tput setaf 1)
bold=$(tput bold)
reset=$(tput sgr0)

echo "192.168.10.20 racknode-1" | tee -a /etc/hosts
echo "192.168.10.30 racknode-2" | tee -a /etc/hosts

# installation of needed packages
echo "${bold}${green}installation of needed packages${reset}"
yum groupinstall -y "Base"
yum groupinstall -y "Core"
yum install -y ntp bind bind-utils  
sudo timedatectl set-timezone Europe/Brussels
sudo systemctl start ntpd

# firewall settings
echo "${bold}${green}firewall settings${reset}"
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-service=ntp
sudo firewall-cmd --permanent --zone=public --add-port=53/udp
sudo firewall-cmd --permanent --zone=public --add-port=53/udp

sudo firewall-cmd --reload
# firewall-cmd --permanent --zone=public --add-rich-rule 'rule family="ipv4" source address="10.0.0.0/8" port port=5500 protocol=tcp accept'

# firewall-cmd --permanent --zone=public --add-rich-rule 'rule family="ipv4" source address="10.0.0.0/8" port port="1521" protocol="tcp" accept'

# enable and start ntpd
echo "${bold}${green} enable and start ntpd${reset}"
timedatectl set-timezone Europe/Brussels
systemctl start ntpd
firewall-cmd --reload
