#!/bin/sh
# dhclient change hostname script for Ubuntu
#oldhostname=$(hostname -s)
#if [ $oldhostname = 'localhost' ]
#then
#sleep 10 # Wait for configuration to be written to disk
hostname=$(cat /var/lib/dhclient/dhclient--eth0.lease  |  awk ' /host-name/ { host = $3 }  END { printf host } ' | sed     's/[";]//g')
# Update /etc/hosts
# Rename Host
echo $hostname > /etc/hostname
hostname -b -F /etc/hostname
echo $hostname > /proc/sys/kernel/hostname
#fi
#rm /etc/init.d/sethostname2.sh
