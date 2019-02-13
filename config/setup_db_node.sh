#!/bin/bash

set -e

# set some colours for the echo commands
green=$(tput setaf2)
red=$(tput setaf1)
bold=$(tput bold)
reset=$(tput sgr0)

echo "192.168.10.20 racknode-1" | tee -a /etc/hosts
echo "192.168.10.30 racknode-2" | tee -a /etc/hosts

# installation of needed packages
echo "${bold}${green}installation of needed packages${reset}"
yum groupinstall -y "Base"
yum groupinstall -y "Core"
yum install -y ntp binutils libX11 compat-libcap1 libXau cpmpat-libstdc++33 libaio libaio-devel gcc libdmx
yum install -y glibc-devel glibc ksh make libgcc sysstat libstdc++ xorg-x11-utils xorg-x11-auth libXext libXv
yum install -y libXtst libXi libxcb libXt libXmu libXxf86misc libXxf86dga LibXxf86vm nfs-utils

# firewall settings
echo "${bold}${green}firewall settings${reset}"
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-service=ntp

# firewall-cmd --permanent --zone=public --add-rich-rule 'rule family="ipv4" source address="10.0.0.0/8" port port=5500 protocol=tcp accept'

# firewall-cmd --permanent --zone=public --add-rich-rule 'rule family="ipv4" source address="10.0.0.0/8" port port="1521" protocol="tcp" accept'

# enable and start ntpd
echo "${bold}${green} enable and start ntpd${reset}"
timedatectl set-timezone Europe/Brussels
systemctl start ntpd
firewall-cmd --reload

# stop and disable avahi-daemon service
echo"${bold}${green}stop and disable avahi-daemon service${reset}"
systemctl stop avahi-dnsconfd
systemctl stop avahi-daemon

systemctl disable avahi-dnsconfd
systemctl disable avahi-daemon

rm '/etc/systemd/system/dbus-org.freedesktop.Avahi.service'
rm '/etc/systemd/system/multi-user.target.wants/avahi-daemon.service'
rm '/etc/systemd/system/sockets.target.wants/avahi-daemon.socket'

# create the needed accounts and groups
echo "${bold}${green}create the needed accounts and groups${reset}"
groupadd --gid 54321 oinstall
groupadd --gid 54322 dba
groupadd --gid 54323 asmdba
groupadd --gid 54324 asmoper
groupadd --gid 54325 asmadmin
groupadd --gid 54326 oper
# optionals but recommended groups
groupadd --gid 54327 backupdba
groupadd --gid 54328 dgdba
groupadd --gid 54329 kmdba

# create the needed users
useradd --uid 54321 --gid oinstall --groups dba,oper,asmdba,asmoper,backupdba,dgdba,kmdba
oracle
: oswd oracle
useradd --uid 54321 --gid oinstall --groups dba,oper,asmdba,asmoper grid
passwd grid

