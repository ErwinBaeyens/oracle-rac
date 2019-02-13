#!/bin/bash

set -e
sudo echo "192.168.10.20 racknode-1" | sudo tee -a /etc/hosts
sudo echo "192.168.10.30 racknode-2" | sudo tee -a /etc/hosts
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-service=ntp
sudo yum install -y ntp binutils libX11 compat-libcap1 libXau cpmpat-libstdc++33 libaio libaio-devel gcc libdmx
sudo yum install -y glibc-devel glibc ksh make libgcc sysstat libstdc++ xorg-x11-utils xorg-x11-auth libXext libXv
sudo yum install -y libXtst libXi libxcb libXt libXmu libXxf86misc libXxf86dga LibXxf86vm nfs-utils
sudo timedatectl set-timezone Europe/Brussels
sudo systemctl start ntpd
sudo firewall-cmd --reload
