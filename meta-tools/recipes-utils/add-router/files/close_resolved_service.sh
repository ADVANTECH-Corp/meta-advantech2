#! /bin/sh

systemctl stop connman.service
systemctl disable connman.service

systemctl stop systemd-resolved.service
systemctl disable systemd-resolved.service

FLAG=`cat /etc/systemd/resolved.conf | grep "#DNS="`
if [ -n $FLAG ]
then
        sed -i "/^#DNS=/s/.*/DNS=8.8.8.8 8.8.4.4/g" /etc/systemd/resolved.conf
        sed -i "s/^#FallbackDNS/FallbackDNS/g" /etc/systemd/resolved.conf
fi

FLAG_rp_filter=`cat /etc/sysctl.conf | grep "net.ipv4.conf.all.rp_filter="`
if [ "$FLAG_rp_filter" == "net.ipv4.conf.all.rp_filter=1" ]
then
        sed -i "s/^net.ipv4.conf.all.rp_filter=1/net.ipv4.conf.all.rp_filter=0/g" /etc/sysctl.conf
        sed -i "s/^net.ipv4.conf.default.rp_filter=1/net.ipv4.conf.default.rp_filter=0/g" /etc/sysctl.conf
elif [ "$FLAG_rp_filter" == "net.ipv4.conf.all.rp_filter=0" ]
then
        systemctl disable close_systemd_resolved.service
fi

sync

