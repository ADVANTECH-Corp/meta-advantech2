#!/bin/sh

if [ "`ifconfig | grep eth0`" == "" ];then
        ifconfig eth0:0 192.168.0.1 netmask 255.255.255.0
fi
if [ "`ifconfig | grep eth1`" == "" ];then
        ifconfig eth1:0 192.168.1.1 netmask 255.255.255.0
fi

