#! /bin/sh

systemctl stop systemd-resolved.service
systemctl disable systemd-resolved.service

systemctl stop connman.service
systemctl disable connman.service

FLAG=`cat /etc/systemd/resolved.conf | grep "#DNS="`
if [ -n $FLAG ]
then
	sed -i "/^#DNS=/s/.*/DNS=8.8.8.8 8.8.4.4/g" /etc/systemd/resolved.conf
	sed -i "s/^#FallbackDNS/FallbackDNS/g" /etc/systemd/resolved.conf
fi

#echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
#echo 0 > /proc/sys/net/ipv4/conf/eth1/rp_filter
#sleep 5
#echo 0 > /proc/sys/net/ipv4/conf/wwan0/rp_filter

sed -i "s/^net.ipv4.conf.all.rp_filter=1/net.ipv4.conf.all.rp_filter=0/g" /etc/sysctl.conf
sed -i "s/^net.ipv4.conf.default.rp_filter=1/net.ipv4.conf.default.rp_filter=0/g" /etc/sysctl.conf
sync

/tools/adv-wwan0.sh 
