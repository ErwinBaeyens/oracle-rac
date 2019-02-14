#!/usr/bin/env bash

# set -e

# set some colours for the echo commands
green=$(tput setaf 2)
red=$(tput setaf 1)
bold=$(tput bold)
reset=$(tput sgr0)

PASSWORD='aich1oF5'
BASEGUID=50000
echo "192.168.10.20 racknode-1" | tee -a /etc/hosts
echo "192.168.10.30 racknode-2" | tee -a /etc/hosts

# installation of needed packages
echo "${bold}${green}installation of needed packages${reset}"

yum groups mark convert
yum groupinstall -y "Base" "Core"

yum install -y <<EOF
ntp
binutils
libX11
compat-libcap1
libXau
cpmpat-libstdc++33
libaio
libaio-devel
gcc
libdmx
glibc-devel
glibc
ksh
make
libgcc
sysstat
libstdc++
xorg-x11-utils
xorg-x11-auth
libXext
libXv
libXtst
libXi
libxcb
libXt
libXmu
libXxf86misc
libXxf86dga
LibXxf86vm
nfs-utils
EOF

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
echo "${bold}${green}stop and disable avahi-daemon service${reset}"

result=$(systemctl is-active avahi-dnsconfd)
if [[ $result == "active" ]]; then
    systemctl stop avahi-dnsconfd
    systemctl stop avahi-daemon

    systemctl disable avahi-dnsconfd
    systemctl disable avahi-daemon
fi

if [[ -e '/etc/systemd/system/dbus-org.freedesktop.Avahi.service' ]]; then
    rm '/etc/systemd/system/dbus-org.freedesktop.Avahi.service'
fi
if [[ -e '/etc/systemd/system/multi-user.target.wants/avahi-daemon.service' ]]; then
    rm '/etc/systemd/system/multi-user.target.wants/avahi-daemon.service'
fi
if [[ -e '/etc/systemd/system/sockets.target.wants/avahi-daemon.socket' ]]; then
    rm '/etc/systemd/system/sockets.target.wants/avahi-daemon.socket'
fi

# create the needed accounts and groups
echo "${bold}${green}create the needed accounts and groups${reset}"
GUID_INDEX=0
for grp in oinstall dba asmdb asmoper asmadmin oper backupdba dgdba kmdba; do
    ((GUID_INDEX=$GUID_INDEX+1))
    ((GUID=$BASEGUID+$GUID_INDEX))
    groupadd --gid $GUID $grp
done

# create the needed users
for user in oracle grid; do
    useradd --gid oinstall --groups dba,oper,asmdba,asmoper,backupdba,dgdba,kmdba oracle
    echo "$user:$PASSWORD" | chpasswd 
done
