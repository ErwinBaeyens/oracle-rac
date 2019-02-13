#!/bin/bash

set -e
sudo echo "192.168.10.20 racknode-1" | sudo tee -a /etc/hosts
sudo echo "192.168.10.30 racknode-2" | sudo tee -a /etc/hosts

# installation of needed packages
echo "installation of needed packages"
sudo yum groupinstall -y "Base"
sudo yum groupinstall -y "Core"
sudo yum install -y ntp binutils libX11 compat-libcap1 libXau cpmpat-libstdc++33 libaio libaio-devel gcc libdmx
sudo yum install -y glibc-devel glibc ksh make libgcc sysstat libstdc++ xorg-x11-utils xorg-x11-auth libXext libXv
sudo yum install -y libXtst libXi libxcb libXt libXmu libXxf86misc libXxf86dga LibXxf86vm nfs-utils

# firewall settings
echo "firewall settings"
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-service=ntp
sudo firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4"source address=10.0.0.0/8" port protocol="tcp" port="1521" accept"
sudo firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4"source address=10.0.0.0/8" port protocol="tcp" port="5500 " accept"

# enable and start ntpd
echo " enable and start ntpd"
sudo timedatectl set-timezone Europe/Brussels
sudo systemctl start ntpd
sudo firewall-cmd --reload

# stop and disable avahi-daemon service
echo"stop and disable avahi-daemon service"
sudo systemctl stop avahi-dnsconfd
sudo systemctl stop avahi-daemon

sudo systemctl disable avahi-dnsconfd
sudo systemctl disable avahi-daemon

rm '/etc/systemd/system/dbus-org.freedesktop.Avahi.service'
rm '/etc/systemd/system/multi-user.target.wants/avahi-daemon.service'
rm '/etc/systemd/system/sockets.target.wants/avahi-daemon.socket'

# create the needed accounts and groups
echo "create the needed accounts and groups"
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

